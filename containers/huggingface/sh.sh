#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


####
pip3 install transformers huggingface_hub
# pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu126 # gpu
pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu # cpu
pip install pysocks
pip3 install --upgrade scipy


####
pip3 install transformers gradio torch
