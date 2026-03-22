#!/usr/bin/env python3
from dotenv import load_dotenv
import anthropic

# ANTHROPIC_BASE_URL=https://api.minimaxi.com/anthropic
load_dotenv("configs/local.env")
client = anthropic.Anthropic()

message = client.messages.create(
    model="MiniMax-M2.7",
    max_tokens=1000,
    system="You are a helpful assistant.",
    messages=[
        {
            "role": "user",
            "content": [
                { "type": "text", "text": "Hi, how are you?" }
            ]
        }
    ]
)

for block in message.content:
    if block.type == "thinking":
        print(f"Thinking:\n{block.thinking}\n")
    elif block.type == "text":
        print(f"Text:\n{block.text}\n")
