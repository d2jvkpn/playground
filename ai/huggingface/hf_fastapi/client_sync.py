#!/usr/bin/env python3
from openai import OpenAI

client = OpenAI(base_url="http://127.0.0.1:8000/v1", api_key="local")

resp = client.chat.completions.create(
    model="local-model",
    messages=[
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "用中文简单介绍你自己"},
    ],
)

print(resp.choices[0].message.content)


emb = client.embeddings.create(
    model="local-embed",
    input=["用中文简单介绍你自己"],
)

print(len(emb.data), len(emb.data[0].embedding))
print(emb.data)

