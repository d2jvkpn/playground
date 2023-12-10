#! /usr/bin/env bash
set -eu -o pipefail

_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})
# set -x

SD_Version=$1

apt update && \
  apt -y upgrade && \
  apt install -y --no-install-recommends \
    git wget tzdata pkg-config python3 python3-pip python3-venv \
    libgl1 libglib2.0-0 libsm6 libxrender1 libxext6

output=stable-diffusion-webui-${SD_Version}; \
  link=https://github.com/AUTOMATIC1111/stable-diffusion-webui/archive/refs/tags/v${SD_Version}.tar.gz; \
  wget -O $output.tar.gz $link && \
  tar -xf $output.tar.gz && \
  mv $output sd-webui

# git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui ./

python3 -m venv sd-webui/venv/ && \
  source sd-webui/venv/bin/activate && \
  pip3 install httpx==0.24.1 xformers && \
  pip3 install -r requirements_versions.txt && \
  pip3 install --upgrade git+https://github.com/huggingface/diffusers.git

mkdir -p sd-webui/extensions && \
  git clone https://github.com/lllyasviel/ControlNet sd-webui/extensions/ControlNet && \
  git clone https://github.com/Mikubill/sd-webui-controlnet sd-webui/extensions/sd-webui-controlnet
  # git clone https://github.com/Uminosachi/sd-webui-inpaint-anything sd-webui/extensions/sd-webui-inpaint-anything

mkdir -p sd-webui/repositories && \
  git clone https://github.com/salesforce/BLIP.git sd-webui/repositories/BLIP && \
  git clone https://github.com/sczhou/CodeFormer.git sd-webui/repositories/CodeFormer && \
  git clone https://github.com/crowsonkb/k-diffusion.git sd-webui/repositories/k-diffusion && \
  git clone https://github.com/Stability-AI/stablediffusion.git sd-webui/repositories/stable-diffusion-stability-ai && \
  git clone https://github.com/CompVis/taming-transformers.git sd-webui/repositories/taming-transformers && \
  git clone https://github.com/Stability-AI/generative-models.git sd-webui/repositories/generative-models

apt remove && \
  apt autoremove && \
  apt clean && \
  apt autoclean && \
  dpkg -l | awk '/^rc/{print $2}' | xargs -i dpkg -P {} && \
  rm -rf /var/lib/apt/lists/*

rm -rf ~/.cache/pip
