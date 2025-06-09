#!/usr/bin/env python3
import os

import requests


"""
curl https://api.openai.com/v1/embeddings \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "text-embedding-ada-002",
    "encoding_format": "float",
    "input": "The food was delicious and the waiter..."
  }'

curl http://localhost:11434/api/embed \
  -H "Content-Type: application/json" \
  -d '{
    "model": "bge-m3:567m",
    "encoding_format": "float",
    "input": "The food was delicious and the waiter..."
  }'
"""


def embedding_api(embeddings, key, source):
    model = embeddings[key]
    headers = { "Content-Type": "application/json", "Authorization": f"Bearer {model.get('api_key', '')}" }

    data = {
        "model": os.path.basename(key),
        "encoding_format": "float",
        "input": source,
    }

    response = requests.post(model['api_base'], headers=headers, json=data)

    if response.status_code == 200:
         return response.json()
    else:
         raise Exception(f"API Error: {response.status_code}, {response.text}")


if __name__ == '__main__':
    config = {
        "ollama/bge-m3:567m": { "api_base": "http://localhost:11434/api/embed" }
    }

    ans = embedding_api(config, "ollama/bge-m3:567m", "The food was delicious and the waiter...")
    print(ans)
