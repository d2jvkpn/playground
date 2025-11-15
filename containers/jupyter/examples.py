#!/usr/bin/env python3

#### 1. pytorch, $ pip show torch
import torch

print(torch.__version__)

is_available = torch.cuda.is_available()
if is_available:
    print(torch.version.cuda)
    print(torch.cuda.get_device_name(0))  # Should display your GPU model
else:
    print("No cuda is available")

#### 2. google colab
import os
from pathlib import Path

from google.colab import userdata, drive

os.environ['HF_USER'] = userdata.get('HF_USER')
os.environ['HF_TOKEN'] = userdata.get('HF_TOKEN')
os.environ['WANDB_API_KEY'] = userdata.get('WANDB_API_KEY')

drive_dir = Path("/mnt/google_drive")
drive.mount(drive_dir)
data_dir = drive_dir / "data"

if os.path.exists(link_name):
    print(f"link name already exists: {link_name}")
else:
    os.symlink(data_dir, "data")

#$ ln -s /mnt/google_drive/MyDrive/data ./data
#print(Path("data").glob("*"))

#### 3. modal
import os

import modal

app = modal.App("demo")

@app.function(secrets=[modal.Secret.from_name("my-secret")])
def run():
    key = os.environ["OPENAI_API_KEY"]
