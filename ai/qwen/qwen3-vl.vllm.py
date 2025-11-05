#!/usr/bin/env python3
import os, base64
from pathlib import Path

from openai import OpenAI


model_id = os.getenv("model_id", "Qwen/Qwen3-VL-2B-Instruct")
vllm_addr = os.getenv("vllm_addr", "http://localhost:8000")

client = OpenAI(base_url=f"{vllm_addr}/v1", api_key="EMPTY")
system_prompt = "Answer concisely with only the final answer. No reasoning, no extra words."

def image_to_uri(p):
    mime = "image/png" if p.lower().endswith(".png") else "image/jpeg"
    #with open(p, "rb") as f:
    #    b64 = base64.b64encode(f.read()).decode("utf-8")

    bts = Path(p).read_bytes()
    b64 = base64.b64encode(bts).decode("utf-8")

    return f"data:{mime};base64,{b64}"


img_path = os.sys.argv[1]
# img_path = "data/images/candy.jpeg"
# img_path = "data/images/receipt.png"
img_url = image_to_uri(img_path)

resp = client.chat.completions.create(
    model=model_id,
    stream=False,
    temperature=0.3,
    max_tokens=64,
    messages=[
        { "role": "system", "content": system_prompt },
        {
            "role": "user",
            "content": [
                #{ "type": "text", "text": "What animal is on the candy?" },
                { "type": "text", "text": "糖果上的是什么动物" },
                { "type": "image_url", "image_url": { "url": img_url } },
                #{ "type": "image_url", "image_url": { "url": "https://example.com/street.jpg" } },
            ],
        },
    ],
)

print(resp.choices[0].message.content)
