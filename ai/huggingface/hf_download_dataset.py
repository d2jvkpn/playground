#!/usr/bin/env python3
import os

import dotenv
from datasets import load_dataset

repo_id = os.sys.argv[1]
dotenv.load_dotenv("configs/local.env")
# os.environ['HF_HOME'] = "data/huggingface"

#cache_dir = "data/huggingface" # default=~/.cache/huggingface/datasets
#os.makedirs(cache_dir, exist_ok=True)

ds = load_dataset(
    repo_id,
    #cache_dir=cache_dir,
)
