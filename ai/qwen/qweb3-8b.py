#!/usr/bin/env python3
from pathlib import Path
from datetime import datetime
from typing import List, Dict, Any, Optional
import re, json

from dotenv import load_dotenv
load_dotenv(Path("configs") / "local.env")
import torch
torch.manual_seed(3647)
#torch.set_float32_matmul_precision('high')
torch.backends.cuda.matmul.fp32_precision = 'ieee'
from transformers import set_seed
set_seed(42)
from transformers import AutoModelForCausalLM, AutoTokenizer, BitsAndBytesConfig

####
device = 'cuda' if torch.cuda.is_available() else 'cpu'
model_name = "Qwen/Qwen3-8B"

print(f"--> device: {device}, model_name: {model_name}")

####
# load the tokenizer and the model
tokenizer = AutoTokenizer.from_pretrained(model_name)

#quant = BitsAndBytesConfig(
#    load_in_4bit=True,
#    bnb_4bit_compute_dtype=torch.bfloat16,
#    bnb_4bit_use_double_quant=True,
#    bnb_4bit_quant_type="nf4",
#)

quant = BitsAndBytesConfig(load_in_8bit=True, bnb_8bit_compute_dtype=torch.bfloat16)
#quant = None

model = AutoModelForCausalLM.from_pretrained(
    model_name,
    dtype="auto",
    device_map="auto",
    quantization_config=quant,
)

tools = [
    {
        "name": "get_weather",
        "description": "Get weather by location",
        "parameters": {
            "type": "object",
            "properties": {"city": {"type": "string"}},
            "required": ["city"],
        },
    },
]

####
def chat(messages, max_new_tokens=1024, thinking=True, tools=None, temperature=0.2):
    prompt = tokenizer.apply_chat_template(
        messages,
        tokenize=False,
        add_generation_prompt=True,
        enable_thinking=thinking, # 若你确认模型是 thinking 版本再开；普通指令版请注释掉
        tools=tools,              # 若这里报参名错误，换成 functions=tools
    )

    inputs_ids = tokenizer([prompt], return_tensors="pt").to(model.device)

    generated_ids = model.generate(
        **inputs_ids,
        max_new_tokens=max_new_tokens, # max_new_tokens=32768
        temperature=temperature,       # 放到 generate 里，而不是 apply_chat_template
        do_sample=(temperature > 0),   # 温度>0时启用采样
        eos_token_id=tokenizer.eos_token_id,
    )

    output_ids = generated_ids[0][len(inputs_ids.input_ids[0]):].tolist() 
    # index = len(output_ids) - output_ids[::-1].index(151668) # </think>
    # output_ids[:index]

    text = tokenizer.decode(output_ids, skip_special_tokens=True)

    return text.strip()


def _as_tool(obj: Any) -> Optional[Dict[str, Any]]:
    ok = isinstance(obj, dict) and "name" in obj and "arguments" in obj
    if not ok:
        return None

    # arguments 允许是 str（未解析的 JSON），也允许是 dict
    args = obj["arguments"]
    if isinstance(args, str): # 尝试把字符串 arguments 转为 dict
        try:
            args = json.loads(args)
        except Exception:
            pass

    return { "name": obj["name"], "arguments": args }

def parse_tool_call(text: str):
    """
    兼容两种常见输出：
    1) 纯 JSON：{"name":"get_weather","arguments":{"city":"Shanghai"}}
    2) 带标签：<|tool_call|>{"name":...}</|tool_call|> 或 <tool_call>...</tool_call>
    """

    m = re.search(r"<\|?tool_call\|?>\s*(\{.*?\})\s*</\|?tool_call\|?>", text, flags=re.S)
    if m:
        text = m.group(1)

    text = text.strip()
    last_brace = text.rfind("}") # 尝试截断到最后一个 '}'（避免结尾带多余自然语言）
    if last_brace != -1:
        text = text[:last_brace+1]

    try:
        obj = json.loads(text)
        if "name" in obj and "arguments" in obj:
            return obj
    except Exception:
        pass

    return None

def parse_tool_calls(text: str) -> List[Dict[str, Any]]:
    """
    从模型输出中解析出 0..N 个工具调用：
    return: [{"name": str, "arguments": dict|str}, ...]
    """
    results: List[Dict[str, Any]] = []

    # 1) 先抓所有标签形式的调用（支持 <tool_call> 与 <|tool_call|>）
    tag_pattern = r"<\|?tool_call\|?>\s*(\{.*?\})\s*</\|?tool_call\|?>"
    for m in re.finditer(tag_pattern, text.strip(), flags=re.S):
        block = m.group(1).strip()
        # 截到最后一个右花括号，避免尾部自然语言
        block = block[: block.rfind("}") + 1] if "}" in block else block
        try:
            obj = json.loads(block)
            tool = _as_tool(obj)
            if tool:
                results.append(tool)
        except Exception:
            continue

    if results:
        return results

    # 2) 没有标签：尝试纯 JSON（对象或数组），先粗暴截到最后一括号，剔除结尾赘语
    if "}" in s:
        s = s[:s.rfind("}") + 1]

    try:
        obj = json.loads(s)
        if isinstance(obj, dict):
            tool = _as_tool(obj)
            if tool:
                return [tool]
        elif isinstance(obj, list):
            for it in obj: # 数组中每个元素应该是一个 tool 对象
                tool = _as_tool(it)
                if tool:
                    results.append(tool)
            if results:
                return results
    except Exception:
        pass

    # 3) 兜底：有些模型会输出多个 JSON 对象串联，用粗略查找提取每段 {...}, 可能匹配到非工具 JSON，解析后再用 _as_tool 过滤
    brace_pattern = r"\{(?:[^{}]|(?R))*\}"  # 递归样式在部分引擎不可用；退而求其次：
    approx_pattern = r"\{[\s\S]*?\}"        # 简化版：匹配看起来像 JSON 的块（容错，不完美）
    for m in re.finditer(approx_pattern, text):
        chunk = m.group(0)
        try:
            obj = json.loads(chunk)
            tool = _as_tool(obj)
            if tool:
                results.append(tool)
        except Exception:
            continue

    return results

####
msgs = [
    {"role": "user", "content": "Give me a short introduction to large language model."},
]
print(chat(msgs))


msgs = [
    {"role": "user", "content": "简要的介绍一下大语言模型(large language models)。"},
]
print(chat(msgs))


messages = [
    #{ "role": "system", "content": "Only return the tool call JSON with keys: name, arguments; no extra text." },
    { "role": "user", "content": "What's the weather in Shanghai?" },
]
text = chat(messages, thinking=False, tools=tools)
print(f"<-- response: \n{text}\n")
print(f"<-- parse_tool_calls:\n{parse_tool_calls(text)}\n")
