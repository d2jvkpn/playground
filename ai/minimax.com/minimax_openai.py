#!/usr/bin/env python3
from dotenv import load_dotenv
from openai import OpenAI

# OPENAI_BASE_URL=https://api.minimaxi.com/v1
load_dotenv("configs/local.env")
client = OpenAI()

response = client.chat.completions.create(
    model="MiniMax-M2.7",
    messages=[
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "Hi, how are you?"},
    ],
    # 设置 reasoning_split=True 将思考内容分离到 reasoning_details 字段
    extra_body={"reasoning_split": True, "enable_thinking": False},
    stream=False,
)

msg = response.choices[0].message
if msg.reasoning_details:
    print(f"Thinking:\n{msg.reasoning_details[0]['text']}\n")

print(f"Text:\n{msg.content}\n")
