#!/bin/python3

from os import sys
import torch, transformers

if len(sys.argv) < 3:
   print("run.py <model_dir>  <content...>")
    sys.exit(1)

# "data/deepseek-ai/deepseek-coder-1.3b-instruct"
# 
model_dir = os.sys.argv[1]
content = " ".join(os.sys.argv[2:])

pipeline = transformers.pipeline(
  "text-generation",
  model=model_dir,
  model_kwargs={"torch_dtype": torch.bfloat16},
  device_map="auto", # gpu, cpu
)

messages = [
  {"role": "user", "content": content},
]

outputs = pipeline(messages, max_new_tokens=2048)

print(outputs[0]["generated_text"][-1]["content"])
