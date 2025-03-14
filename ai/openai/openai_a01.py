import os, argparse
#from os import sys

import yaml
from openai import OpenAI

#config_file = sys.argv[1] if len(sys.argv) > 1 else  "configs/dev.yaml"

parser = argparse.ArgumentParser(description="parse commandline arguments")
#parser.add_argument("config", help="config path", default="configs/dev.yaml")
parser.add_argument("-c", "--config", help="config path", default="configs/dev.yaml")
parser.add_argument("-v", "--verbose", help="verbose", action="store_true")
parser.add_argument("-n", "--number", type=int, help="a number", default=10)
args = parser.parse_args()

https_proxy = configs.get("https_proxy", "")
if https_proxy != "":
    os.environ["https_proxy"] = https_proxy

with open(args.config, 'r') as f:
    configs = yaml.safe_load(f)

client = OpenAI(api_key=configs["openai"]["api_key"])
model = configs["openai"].get("model",  "gpt-3.5-turbo")
print(f"--> model={model}")

response = client.chat.completions.create(
    model = model,
    messages = [
      { "role": "user", "content": "Hello, World!"},
    ],
    max_tokens=50,
)
ans = response.choices[0].message.content.strip()
print(f"Ans: {ans}")
