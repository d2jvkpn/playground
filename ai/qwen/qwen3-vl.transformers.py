#!/usr/bin/env python3
import os, time, json
from pathlib import Path
from datetime import datetime

from dotenv import load_dotenv
load_dotenv(Path("configs") / "local.env")
import PIL.Image as Image
import torch
from transformers import AutoProcessor, AutoModelForImageTextToText, BitsAndBytesConfig

####
def now():
    return datetime.now().astimezone().strftime("%FT%T%:z")

def hf_model_path(model_id):
    hf_hub_cache = os.environ.get("HF_HUB_CACHE", Path.home() / ".cache" / "huggingface" / "hub")

    model_dir = Path(hf_hub_cache) / ("models--" + model_id.replace("/", "--"))
    model_ref = (model_dir / "refs" / "main").read_text(encoding="utf-8").strip()

    return model_dir / "snapshots" / model_ref

prompt_cn = """"
请直接给出答案，不要解释或输出其他内容。
问题：{}
答案：
""".strip()

prompt_en = """
Answer concisely with only the final answer. No reasoning, no extra words.
Question: {}
Answer: 
""".strip()

####
model_id = os.getenv("model_id", "Qwen/Qwen3-VL-4B-Instruct")
quantization = os.getenv("quantization", "q4").lower()

model_path = hf_model_path(model_id)

if quantization == "q4":
    bnb = BitsAndBytesConfig(
        load_in_4bit=True,
        bnb_4bit_use_double_quant=True,
        bnb_4bit_compute_dtype=torch.float16,
        bnb_4bit_quant_type="nf4",
    )
elif quantization == "q8":
    bnb = BitsAndBytesConfig(
        load_in_8bit=True,
        bnb_8bit_compute_dtype=torch.float16,
    )
else:
    bnb = None

print(f"==> model_id={model_id}, quantization={quantization}", file=os.sys.stderr)

processor = AutoProcessor.from_pretrained(model_path)

model = AutoModelForImageTextToText.from_pretrained(
    model_path,
    quantization_config=bnb,
    #dtype=torch.float16,
    dtype="auto",
    device_map="auto",
    trust_remote_code=True,
)

####
img_path = os.sys.argv[1]
# img_path = "data/images/candy.jpeg"
# img_path = "data/images/receipt.png"

question = " ".join(os.sys.argv[2:])
# question = "What animal is on the candy?"
# question = "Read all the text in the image."

image = Image.open(img_path).convert("RGB")

msgs = [
    {
        "role": "system",
        "content": "Answer concisely with only the final answer. No reasoning, no extra words.",
    },
    {
        "role": "user",
        "content": [
            { "type": "image" },
            #{ "type": "text", "text": prompt_en.format(question) },
            { "type": "text", "text": question },
        ],
    },
]

t0 = time.time()

text = processor.apply_chat_template(msgs, add_generation_prompt=True)
inputs = processor(text=text, images=[image], return_tensors="pt").to(model.device)
#outputs = model.generate(**inputs, temperature=0.2, max_new_tokens=64)
#answser = processor.batch_decode(outputs, skip_special_tokens=True)[0].split("assistant")[-1]
outputs = model.generate(**inputs, temperature=0.2, max_new_tokens=64)
output_ids = outputs[0][inputs["input_ids"].shape[-1]:]
answser = processor.decode(output_ids, skip_special_tokens=True)

elapsed = round(time.time() - t0, 3)

data = {
    "model": model_id,
    #"created_at": now(),
    "created_at": int(time.time()),
    "elapsed": elapsed,
    "messages": [
        {
            "role": "assistant",
            "content": [{"type": "text", "text": answser}],
        },
    ],
}

response = json.dumps(data, ensure_ascii=False)
print(response)
