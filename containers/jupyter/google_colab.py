#!/usr/bin/env python3
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
