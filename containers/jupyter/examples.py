#!/usr/bin/env python3

#### 1. torch, $ pip show torch
import torch

print(torch.cuda.is_available(), torch.version.cuda)


#### 2. google colab
import os
from pathlib import Path

from google.colab import userdata, drive

os.environ['HF_USER'] = userdata.get('HF_USER')
os.environ['HF_TOKEN'] = userdata.get('HF_TOKEN')
os.environ['WANDB_API_KEY'] = userdata.get('WANDB_API_KEY')

drive.mount("/mnt/google_drive")
data_dir = Path("/mnt/google_drive/data")
link_name = "data"

if os.path.exists(link_name):
    print(f"link name already exists: {link_name}")
else:
    os.symlink(data_dir, link_name)

#$ ln -s /mnt/google_drive/MyDrive/data ./data
#print(Path("data").glob("*"))

#### 3. modal
import os

import modal

app = modal.App("demo")

@app.function(secrets=[modal.Secret.from_name("my-secret")])
def run():
    key = os.environ["OPENAI_API_KEY"]
