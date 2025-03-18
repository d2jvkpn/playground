#!/usr/bin/env python3

import os, argparse
from os import sys, path


# e.g. ./huggingface.py down -m deepseek-ai/deepseek-coder-1.3b-instruct
# e.g. ./huggingface.py run -m deepseek-ai/deepseek-coder-1.3b-instruct

#### 1.
parser = argparse.ArgumentParser(description="parse commandline arguments")
parser.add_argument("command", help="command name", choices=["download", "run"])

parser.add_argument("-m", "--model",
  help="model name: sentence-transformers/all-MiniLM-L6-v2, deepseek-ai/deepseek-coder-1.3b-instruct",
  required=True, default="",
)

parser.add_argument("-d", "--dir", help="directory", default="data")
parser.add_argument("-c", "--content", help="message content", default="Hello!")

args = parser.parse_args()

model_dir = path.join(args.dir, args.model)

#### 2.
if args.command == "download":
    from transformers import AutoTokenizer, AutoModel

    os.makedirs(model_dir, mode=511, exist_ok=True)

    print(f"==> downloading: model_dir={model_dir}")
    tokenizer = AutoTokenizer.from_pretrained(args.model, cache_dir=model_dir)
    model = AutoModel.from_pretrained(args.model, cache_dir=model_dir)

    model.save_pretrained(model_dir)
    tokenizer.save_pretrained(model_dir)
    print("<== done")
elif args.command == "run":
    import torch, transformers

    pipeline = transformers.pipeline(
      "text-generation",
      model=model_dir,
      model_kwargs={"torch_dtype": torch.bfloat16},
      device_map="auto", # gpu, cpu
    )

    messages = [
      {"role": "user", "content": args.content},
    ]

    outputs = pipeline(messages, max_new_tokens=2048)

    print(outputs[0]["generated_text"][-1]["content"])
