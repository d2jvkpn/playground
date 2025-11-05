#!/usr/bin/env python3
import base64

from openai import OpenAI


client = OpenAI(base_url="http://localhost:8000/v1", api_key="EMPTY")
system_prompt = "Answer concisely with only the final answer. No reasoning, no extra words."

def image_to_uri(path):
    mime = "image/png" if path.lower().endswith(".png") else "image/jpeg"
    #with open(path, "rb") as f:
    #    b64 = base64.b64encode(f.read()).decode("utf-8")
    b64 = base64.b64encode(bts).decode("utf-8")

    return f"data:{mime};base64,{b64}"

img_uri = image_to_uri("data/images/candy.jpeg")

resp = client.chat.completions.create(
    model="Qwen/Qwen3-VL-2B-Instruct",
    stream=False,
    temperature=0.3,
    max_tokens=256,
    messages=[
        { "role": "system", "content": system_prompt },
        {
            "role": "user",
            "content": [
                #{ "type": "text", "text": "What animal is on the candy?" },
                { "type": "text", "text": "糖果上的是什么动物" },
                { "type": "image_url", "image_url": { "url": img_uri } },
                #{ "type": "image_url", "image_url": { "url": "https://example.com/street.jpg" } },
            ],
        },
    ],
)

print(resp.choices[0].message.content)
