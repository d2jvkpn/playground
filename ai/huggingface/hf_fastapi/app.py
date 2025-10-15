#!/usr/bin/env python3
import os, time, uuid
from pathlib import Path
from typing import List, Optional, Literal, Dict, Any, Generator, Union
import threading

from dotenv import load_dotenv
load_dotenv(Path("configs") / "local.env")
import torch
from transformers import (
    AutoTokenizer,
    AutoModelForCausalLM,
    TextIteratorStreamer,
    BitsAndBytesConfig,
)
from fastapi import FastAPI, HTTPException, Depends, Request
from fastapi.responses import JSONResponse, StreamingResponse
from pydantic import BaseModel, Field

#### 1. init
DEVICE = "cuda" if torch.cuda.is_available() else "cpu"
DTYPE = torch.float16 if DEVICE == "cuda" else torch.float32

MODEL_PATH = os.getenv("MODEL_PATH", "./models/YourHFModel")
MODEL_NAME = os.path.basename(MODEL_PATH)
QUANTIZE = os.getenv("QUANTIZE", "none").lower()
EMBED_NORMALIZE = os.getenv("EMBED_NORMALIZE", "false").lower() in ("1", "true", "yes")
API_KEY = os.getenv("API_KEY", "local")



#### 2. load
# ===== 启动时加载模型/分词器 =====
print(f"==> Loading model from {MODEL_PATH} on {DEVICE} ...")
tokenizer = AutoTokenizer.from_pretrained(MODEL_PATH, use_fast=True)

if tokenizer.pad_token_id is None and tokenizer.eos_token_id is not None:
    tokenizer.pad_token = tokenizer.eos_token

model_kwargs = dict(
    torch_dtype=(torch.float16 if DEVICE == "cuda" and not BNB_CONFIG else None),
    device_map="auto" if DEVICE == "cuda" else None,
)

if QUANTIZE == "4bit":
    model_kwargs["quantization_config"] = BitsAndBytesConfig(
        load_in_4bit=True,
        bnb_4bit_use_double_quant=True,
        bnb_4bit_quant_type="nf4",
        bnb_4bit_compute_dtype=torch.bfloat16,
    )
elif QUANTIZE == "8bit" and DEVICE == "cuda":
    model_kwargs["quantization_config"] = BitsAndBytesConfig(load_in_8bit=True)


model = AutoModelForCausalLM.from_pretrained(MODEL_PATH, **model_kwargs)
model.eval()
print("==> Model loaded.")

#### 3. data models
# ===== OpenAI 兼容的请求/响应Schema（简化） =====
class ModelItem(BaseModel):
    id: str
    object: Literal["model"] = "model"
    created: int
    owned_by: str = "local"
    permission: List[dict] = []
    root: Optional[str] = None
    parent: Optional[str] = None

class ModelList(BaseModel):
    object: Literal["list"] = "list"
    data: List[ModelItem]

class ChatMessage(BaseModel):
    role: Literal["system", "user", "assistant"]
    content: str

class ChatCompletionRequest(BaseModel):
    model: Optional[str] = None
    messages: List[ChatMessage]
    temperature: float = 0.7
    top_p: float = 1.0
    max_tokens: int = 512
    stop: Optional[List[str]] = None
    stream: bool = False

class DeltaMessage(BaseModel):
    role: Optional[str] = None
    content: Optional[str] = None

class ChatChoice(BaseModel):
    index: int
    message: Optional[ChatMessage] = None
    finish_reason: Optional[str] = None

class ChatCompletionResponse(BaseModel):
    id: str
    object: Literal["chat.completion"]
    created: int
    model: str
    choices: List[ChatChoice]
    usage: Optional[Dict[str, int]] = None

# OpenAI embeddings API 兼容
# https://platform.openai.com/docs/api-reference/embeddings/create
class EmbeddingsRequest(BaseModel):
    model: Optional[str] = None
    input: Union[str, List[str]]  # 单条或多条
    encoding_format: Optional[Literal["float", "base64"]] = "float"  # 我们先实现 float
    user: Optional[str] = None

class EmbeddingItem(BaseModel):
    object: Literal["embedding"] = "embedding"
    index: int
    embedding: List[float]

class EmbeddingsResponse(BaseModel):
    object: Literal["list"] = "list"
    data: List[EmbeddingItem]
    model: str
    usage: Optional[Dict[str, int]] = None

#### 4. functions
# ===== 简单的API Key校验 =====
def require_api_key(request: Request):
    auth = request.headers.get("Authorization", "")
    token = auth.replace("Bearer ", "").strip()

    if token != API_KEY:
        raise HTTPException(status_code=401, detail="Unauthorized")

    return True

def catalog_models() -> List[ModelItem]:
    items = []

    items.append(ModelItem(
        id=MODEL_NAME,
        created=int(time.time()),
        owned_by="local-chat",
        root=MODEL_NAME,
    ))

    return items

# ===== 将messages转成prompt =====
def build_prompt(messages: List[ChatMessage]) -> str:
    """
     尽量贴近常见chat模板：
    - 优先用 tokenizer.apply_chat_template（若模型支持）
    - 否则回落到简单拼接
    """
    if hasattr(tokenizer, "apply_chat_template"):
        try:
            return tokenizer.apply_chat_template(
                [m.model_dump() for m in messages],
                tokenize=False,
                add_generation_prompt=True,
            )
        except Exception:
            pass

    # fallback 简单模板
    lines = []
    system_prefix = ""

    for m in messages:
        if m.role == "system":
            system_prefix += f"{m.content}\n"

    if system_prefix:
        lines.append(f"[SYSTEM]\n{system_prefix}".strip())

    for m in messages:
        if m.role == "user":
            lines.append(f"[USER]\n{m.content}")
        elif m.role == "assistant":
            lines.append(f"[ASSISTANT]\n{m.content}")

    lines.append("[ASSISTANT]\n")  # generation starts
    return "\n".join(lines)

def truncate_by_stop(text: str, stops: List[str]) -> str:
    cut = len(text)

    for s in stops:
        idx = text.find(s)
        if idx != -1:
            cut = min(cut, idx)

    return text[:cut]

# ===== 生成函数（非流式）=====
@torch.inference_mode()
def generate_once(
    prompt: str,
    temperature: float,
    top_p: float,
    max_new_tokens: int,
    stop: Optional[List[str]] = None,
) -> str:
    inputs = tokenizer(prompt, return_tensors="pt").to(model.device)

    generated_ids = model.generate(
        **inputs,
        do_sample=True if temperature > 0 else False,
        temperature=max(0.01, temperature),
        top_p=top_p,
        max_new_tokens=max_new_tokens,
        eos_token_id=tokenizer.eos_token_id,
        pad_token_id=tokenizer.eos_token_id,
    )

    output_ids = generated_ids[0][inputs["input_ids"].shape[1]:]
    text = tokenizer.decode(output_ids, skip_special_tokens=True)

    if stop:
        text = truncate_by_stop(text, stop)

    return text

# ===== 生成函数（流式SSE）=====
@torch.inference_mode()
def generate_stream(
    prompt: str,
    temperature: float,
    top_p: float,
    max_new_tokens: int,
    stop: Optional[List[str]] = None,
) -> Generator[str, None, None]:
    inputs = tokenizer(prompt, return_tensors="pt").to(model.device)
    streamer = TextIteratorStreamer(tokenizer, skip_prompt=True, skip_special_tokens=True)

    gen_kwargs = dict(
        **inputs,
        streamer=streamer,
        do_sample=True if temperature > 0 else False,
        temperature=max(0.01, temperature),
        top_p=top_p,
        max_new_tokens=max_new_tokens,
        eos_token_id=tokenizer.eos_token_id,
        pad_token_id=tokenizer.eos_token_id,
    )

    thread = threading.Thread(target=model.generate, kwargs=gen_kwargs)
    thread.start()

    acc_text = ""
    for piece in streamer:
        acc_text += piece
        # stop 检查：若命中则截断后结束
        if stop and any(s in acc_text for s in stop):
            acc_text = truncate_by_stop(acc_text, stop)
            yield sse_data(delta=piece, finish=False)
            break

        yield sse_data(delta=piece, finish=False, model_name=model_name)

    yield sse_data(delta="", finish=True, model_name=model_name)
    yield "data: [DONE]\n\n"

def sse_data(delta: str, finish: bool, model_name: str) -> str:
    payload = {
        "id": f"chatcmpl-{uuid.uuid4().hex[:10]}",
        "object": "chat.completion.chunk",
        "created": int(time.time()),
        "model": model_name,
        "choices": [{
            "index": 0,
            "delta": {"content": delta} if delta else {},
            "finish_reason": "stop" if finish else None,
        }],
    }

    return f"data: {payload}\n\n".replace("'", '"')

# ===== token统计（粗略）=====
def estimate_usage(prompt: str, completion: str) -> Dict[str, int]:
    pt = len(tokenizer(prompt).input_ids)
    ct = len(tokenizer(completion).input_ids)
    return { "prompt_tokens": pt, "completion_tokens": ct, "total_tokens": pt + ct }

# Embedding 计算：mean pooling
@torch.inference_mode()
def embed_texts(texts: List[str]) -> List[List[float]]:
    inputs = tokenizer(texts, padding=True, truncation=True, return_tensors="pt")
    inputs = {k: v.to(model.device) for k, v in inputs.items()}

    outputs = model(**inputs, output_hidden_states=False, return_dict=True)
    last_hidden = getattr(outputs, "last_hidden_state", None)

    if last_hidden is None:
        if getattr(outputs, "hidden_states", None) is not None:
            last_hidden = outputs.hidden_states[-1]
        else:
            outputs2 = model(**inputs, output_hidden_states=True, return_dict=True)
            last_hidden = outputs2.hidden_states[-1]

    attention_mask = inputs["attention_mask"].unsqueeze(-1)  # [B, L, 1]

    masked = last_hidden * attention_mask
    sums = masked.sum(dim=1)                         # [B, H]
    counts = attention_mask.sum(dim=1).clamp(min=1)  # [B, 1]
    embs = sums / counts

    if EMBED_NORMALIZE:
        embs = torch.nn.functional.normalize(embs, p=2, dim=1)

    return embs.to(dtype=torch.float32).cpu().tolist()

#### 5. api
app = FastAPI(title="Local OpenAI-compatible API")

# ===== 健康检查 =====
@app.get("/health")
def health():
    return { "status": "ok", "model": MODEL_NAME, "device": DEVICE, "quantize": QUANTIZE }

# ===== OpenAI 兼容 /v1/chat/completions =====
@app.post("/v1/chat/completions")
def chat_completions(req: ChatCompletionRequest, _: bool = Depends(require_api_key)):
    created = int(time.time())
    comp_id = f"chatcmpl-{uuid.uuid4().hex[:10]}"
    model_name = req.model or MODEL_NAME

    prompt = build_prompt(req.messages)

    if req.stream:
        def event_gen():
            for chunk in generate_stream(
                prompt,
                temperature=req.temperature,
                top_p=req.top_p,
                max_new_tokens=req.max_tokens,
                stop=req.stop,
            ):
                yield chunk

        return StreamingResponse(event_gen(), media_type="text/event-stream")

    # 非流式一次性返回
    text = generate_once(
        prompt,
        temperature=req.temperature,
        top_p=req.top_p,
        max_new_tokens=req.max_tokens,
        stop=req.stop,
    )

    usage = estimate_usage(prompt, text)
    msg = ChatMessage(role="assistant", content=text)

    resp = ChatCompletionResponse(
        id=comp_id,
        object="chat.completion",
        created=created,
        model=model_name,
        choices=[ChatChoice(index=0, message=msg, finish_reason="stop")],
        usage=usage,
    )

    return JSONResponse(resp.model_dump())

@app.post("/v1/embeddings")
def create_embeddings(req: EmbeddingsRequest, _: bool = Depends(require_api_key)):
    model_name = req.model or MODEL_NAME

    texts = req.input if isinstance(req.input, list) else [req.input]
    vectors = embed_texts(texts)

    data = [
        EmbeddingItem(index=i, embedding=vectors[i])
        for i in range(len(vectors))
    ]

    pt = sum([len(tokenizer(t).input_ids) for t in texts])
    usage = { "prompt_tokens": pt, "total_tokens": pt }

    resp = EmbeddingsResponse(data=data, model=model_name, usage=usage)

    return JSONResponse(resp.model_dump())

@app.get("/v1/models")
def list_models(_: bool = Depends(require_api_key)):
    return ModelList(data=catalog_models()).model_dump()

@app.get("/v1/models/{model_id}")
def retrieve_model(model_id: str, _: bool = Depends(require_api_key)):
    items = catalog_models()

    for it in items:
        if it.id == model_id:
            return it.model_dump()

    raise HTTPException(
        status_code=404,
        detail={"error": {"message": "Model not found", "type": "invalid_request_error"}},
    )
