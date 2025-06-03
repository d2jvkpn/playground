#!/usr/bin/env python3
import os, argparse

import yaml, openai
from openai import OpenAI


#### 1.
parser = argparse.ArgumentParser(description="parse commandline arguments")
parser.add_argument("command", help="command name", choices=["responses", "chat", "models"])

parser.add_argument("-c", "--config", help="config path", default="configs/dev.yaml")
parser.add_argument("-v", "--verbose", help="verbose", action="store_true")

parser.add_argument("--model", help="model name: gpt-3.5-turbo, gpt-4o", default="gpt-4o")
parser.add_argument("--max_tokens", help="max tokens", type=int, default=1000)
#parser.add_argument('msg', help="message", nargs='*')
parser.add_argument('--content', help="message content", default="Hello")
parser.add_argument('--instructions', help="instructions content", default="")

args = parser.parse_args() # args = parser.parse_args(["chat"])

#### 2.
with open(args.config, 'r') as f:
    configs = yaml.safe_load(f)

os.environ["https_proxy"] = configs.get("https_proxy", "")

api_key = configs["openai"].get("api_key", "")
assert(api_key != "")

##### 3.
client = OpenAI(api_key=api_key)

if args.command == "chat":
    print(f"QUESTION: {args.content}")

    response = client.chat.completions.create(
      model=args.model,
      max_tokens=args.max_tokens,
      messages=[
        { "role": "user", "content": args.content },
      ],
    )

    ans = response.choices[0].message.content.strip()
    print(f"ANSWER: {ans}")
elif args.command == "responses":
    response = client.responses.create(
        model=args.model,
        instructions=args.instructions,
        input=args.content,
    )

    print(response.output_text)
elif args.command == "models":
    models = client.models.list()
    print(models.model_dump_json(indent=2))
