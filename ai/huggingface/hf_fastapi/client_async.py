#!/usr/bin/env python3
import asyncio

from openai import AsyncOpenAI

client = AsyncOpenAI(base_url="http://127.0.0.1:8000/v1", api_key="local")

async def async_chat():
    response = await client.chat.completions.create(
        model="local-model",
        messages=[{"role":"user","content":"来一段打油诗"}],
    )

    print(response.choices[0].message.content)

#### Error
async def async_stream():
    stream = await client.chat.completions.create(
        model="local-model",
        messages=[{"role": "user", "content": "用3个词描述人工智能"}],
        stream=True,
    )

    async for chunk in stream:
        content = chunk.choices[0].delta.content
        if content:
            print(content, end="", flush=True)

asyncio.run(async_chat())
