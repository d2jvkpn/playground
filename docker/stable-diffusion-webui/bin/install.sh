#! /usr/bin/env bash
set -eu -o pipefail

_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})
# set -x

#SD_Version=1.6.0

#apt install -y --no-install-recommends \
#  git wget tzdata pkg-config python3 python3-pip python3-venv \
#  libgl1 libglib2.0-0 libsm6 libxrender1 libxext6

#sdw=stable-diffusion-webui; \
#  link=https://github.com/AUTOMATIC1111/${sdw}/archive/refs/tags/v${SD_Version}.tar.gz; \
#  wget -O ${sdw}-${SD_Version}.tar.gz $link && \
#  tar -xf ${sdw}-${SD_Version}.tar.gz && \
#  mv ${sdw}-${SD_Version} sd-webui

#cd sd-webui

# git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui ./

python3 -m venv venv/ && \
  source venv/bin/activate && \
  pip3 install httpx==0.24.1 xformers && \
  pip3 install -r requirements_versions.txt && \
  pip3 install --upgrade git+https://github.com/huggingface/diffusers.git && \
  rm -rf ~/.cache/pip

mkdir -p extensions && \
  git clone https://github.com/lllyasviel/ControlNet extensions/ControlNet && \
  git clone https://github.com/Mikubill/sd-webui-controlnet extensions/sd-webui-controlnet && \
  # git clone https://github.com/Uminosachi/sd-webui-inpaint-anything extensions/sd-webui-inpaint-anything && \
  mkdir -p repositories && \
  git clone https://github.com/salesforce/BLIP.git repositories/BLIP && \
  git clone https://github.com/sczhou/CodeFormer.git repositories/CodeFormer && \
  git clone https://github.com/crowsonkb/k-diffusion.git repositories/k-diffusion && \
  git clone https://github.com/Stability-AI/stablediffusion.git repositories/stable-diffusion-stability-ai && \
  git clone https://github.com/CompVis/taming-transformers.git repositories/taming-transformers && \
  git clone https://github.com/Stability-AI/generative-models.git repositories/generative-models && \
  rm -rf ~/.cache/pip