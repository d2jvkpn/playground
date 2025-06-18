#!/usr/bin/env python3

import requests

url = "https://api.example.com/llm/stream"
headers = {"Authorization": "Bearer YOUR_API_KEY"}
data = {"prompt": "Tell me a long story"}

response = requests.post(url, headers=headers, json=data, stream=True)


for chunk in response.iter_content(chunk_size=None):
    if chunk:
        # 处理流式数据
        print(chunk.decode('utf-8'), end='', flush=True)
