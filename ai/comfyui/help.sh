#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit
python -c "import torch; print(torch.__version__)"

exit
#### disable FETCH ComfyRegistry Data: 5/113
mv custom_nodes/ComfyUI-Manager custom_nodes/ComfyUI-Manager.disabled

exit
apt-get install -y --no-install-recommends software-properties-common ca-certificates
add-apt-repository ppa:ubuntuhandbook1/ffmpeg8
apt-get update
apt-get install -y ffmpeg

exit
apt-get upgrade -y --no-install-recommends

#site: https://pytorch.org/get-started/previous-versions/
pip index versions torch --index-url https://download.pytorch.org/whl/cu128

pip install --no-cache-dir torch==2.9.0 torchvision==0.24.0 torchaudio==2.9.0 \
  --index-url https://download.pytorch.org/whl/cu128

pip install --no-cache-dir xformers bitsandbytes transformers
pip install --no-cache-dir --no-build-isolation flash-attn


ENV HF_HUB_OFFLINE=True \
  HF_HOME=data/huggingface \
  HF_HUB_CACHE=data/huggingface/hub \
  HF_DATASETS_CACHE=data/huggingface/datasets

exit
proxy_addr=http://host.docker.internal:8118

# --no-cache --target base
docker build \
  --add-host=host.docker.internal:host-gateway \
  --network=host \
  --build-arg HTTP_PROXY="${proxy_addr}" \
  --build-arg HTTPS_PROXY="${proxy_addr}" \
  -f Containerfile \
  -t local/comfyui-base:cuda12.8-ubuntu24.04 ./
