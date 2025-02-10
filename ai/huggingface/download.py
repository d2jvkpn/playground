#!/bin/python3

import os
from os import sys, path

from transformers import AutoTokenizer, AutoModel

# e.g. deepseek-ai/deepseek-coder-1.3b-instruct
# e.g. sentence-transformers/all-MiniLM-L6-v2
model_name =  sys.argv[1]

model_dir = path.join("data", model_name)
os.makedirs(model_dir, mode=511, exist_ok=True)

print(f"==> downloading: model_name={model_name}, model_dir={model_dir}")
tokenizer = AutoTokenizer.from_pretrained(model_name, cache_dir=model_dir)
model = AutoModel.from_pretrained(model_name, cache_dir=model_dir)

model.save_pretrained(model_dir)
tokenizer.save_pretrained(model_dir)
print("<== done")

#pip install huggingface_hub
#from huggingface_hub import snapshot_download

#model_name = "bert-base-uncased"
#local_model_path = "./data"
#snapshot_download(repo_id=model_name, local_dir=local_model_path)
