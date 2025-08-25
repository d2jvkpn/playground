#!/usr/bin/env python3
import os

from google.colab import drive
from google.colab import userdata


os.environ['HF_USER'] = userdata.get('HF_USER')
os.environ['HF_TOKEN'] = userdata.get('HF_TOKEN')
os.environ['WANDB_API_KEY'] = userdata.get('WANDB_API_KEY')

drive.mount('/mnt/google_drive')
#$ ln -s /mnt/google_drive/MyDrive/data ./data
