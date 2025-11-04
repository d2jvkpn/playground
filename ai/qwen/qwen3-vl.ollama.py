#!/usr/bin/env python
import os, base64, json
from pathlib import Path
from typing import Union

import requests


def file_to_b64(p: Union[str, Path]) -> str:
    #with open(path, "rb") as f:
    #    bts = f.read()
    bts = Path(p).read_bytes()
    output = base64.b64encode(bts).decode("utf-8")
    return output


ollama_addr = os.getenv("ollama_addr", "http://localhost:11434")
model_id = os.getenv("model_id", "qwen3-vl:2b") # "qwen3-vl:4b"

chat_endpoint = f"{ollama_addr}/api/chat"

payload = {
  "model": model_id,
  "stream": False,
  "messages": [
    {
      "role": "system",
      "content": "Answer concisely with only the final answer. No reasoning, no extra words.",
    },
    {
      "role": "user",
      "content": "What animal is on the candy?",
      "images": [file_to_b64("data/images/candy.jpeg")],
    },
  ],
}

resp = requests.post(
    chat_endpoint,
    headers={"Content-Type": "application/json"},
    data=json.dumps(payload),
)

print(f"status_code={resp.status_code}", file=os.sys.stderr)
data = resp.json()

answer = data["message"]["content"].strip()
print(answer)


#from ollama import Client

#client = Client(host="http://localhost:11434", headers={'Authorization': 'YOUR_API_KEY'})

#response = client.chat(
#  model="qwen3-vl:2b", # "qwen3-vl:235b-cloud",
#  messages=[
#    {
#      'role': 'user',
#      'content': 'Translate the menu in the image to English.',
#      'images': ['https://example.com/menu.png'],
#    },
#  ],
#)

#print(response.message.content)
#print(response.message.thinking)
