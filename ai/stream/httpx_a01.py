#!/usr/bin/env python3

import httpx
import asyncio

async def stream_llm_response():
    url = "https://api.example.com/llm/stream"
    headers = {"Authorization": "Bearer YOUR_API_KEY"}
    data = {"prompt": "Tell me a long story"}
    
    async with httpx.AsyncClient() as client:
        async with client.stream("POST", url, headers=headers, json=data) as response:
            async for chunk in response.aiter_text():
                print(chunk, end='', flush=True)

asyncio.run(stream_llm_response())
