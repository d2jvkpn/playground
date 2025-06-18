#!/usr/bin/env python3

import requests


def stream_llm_sse():
    url = "https://api.example.com/llm/sse-stream"
    headers = {
        "Accept": "text/event-stream",
        "Authorization": "Bearer YOUR_API_KEY",
    }
    data = {"prompt": "Tell me a long story"}
    
    response = requests.post(url, headers=headers, json=data, stream=True)
    
    for line in response.iter_lines():
        if line:
            decoded_line = line.decode('utf-8')
            if decoded_line.startswith("data:"):
                print(decoded_line[5:].strip())

