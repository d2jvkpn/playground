#!/usr/bin/env python3
#import os
from typing import Dict, Union

import requests


"""
curl https://api.openai.com/v1/embeddings \
  -H "Authorization: Bearer $API_KEY" \
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

response
{
  "model": "bge-m3:567m",
  "embeddings": [
    [
      0.00902439,
      -0.00109302,
      -0.045277692,
      0.004761292,
      -0.026504604,
      -0.03914097,
      0.032382935,
      ....
    ]
  ],
  "total_duration": 2311855724,
  "load_duration": 2237453381,
  "prompt_eval_count": 11
}
"""


def embedding_api(config: Dict, name: str, content: Union[str, list[str]]):
    api_key = config.get('api_key', '')

    headers = { "Content-Type": "application/json", "Authorization": f"Bearer {api_key}" }
    data = { "model": name, "encoding_format": "float", "input": content }

    response = requests.post(config['api_base'], headers=headers, json=data)

    if response.status_code == 200:
         return response.json()
    else:
         raise Exception(f"API Error: {response.status_code}, {response.text}")


if __name__ == '__main__':
    #config = {
    #    "ollama/bge-m3:567m": { "api_base": "http://localhost:11434/api/embed" }
    #}

    config = { "api_base": "http://localhost:11434/api/embed" }

    ans = embedding_api(config, "bge-m3:567m", "The food was delicious and the waiter...")
    print(ans)
