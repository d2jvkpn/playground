#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})


docker save sd-webui:$SD_Version -o sd-webui_$SD_Version.tar
pigz sd-webui_$SD_Version.tar

# mkdir -p outputs

# docker run -d --name sd-webui --gpus=all -p 7860:7860 \
#   -v $PWD/cache:/home/hello/.cache \
#   -v $PWD/models:/home/hello/stable-diffusion-webui/models \
#   -v $PWD/outputs:/home/hello/stable-diffusion-webui/outputs \
#   sd-webui:$SD_Version /entrypoint.sh --listen --api --port=7860

# manual operations on webui: txt2img, CLIP, img2img with controlnet

# wget -O models/Stable-diffusion/512-base-ema.ckpt \
#   https://huggingface.co/stabilityai/stable-diffusion-2-base/resolve/main/512-base-ema.ckpt

# timeout 120 python3 launch.py --skip-torch-cuda-test --listen --api --port=7860 || true
# rm -r /home/hello/.cache/pip models/Stable-diffusion/*.safetensors

#### Ensure compatibility between the versions of xformers and torch
# pip3 install ipython xformers

# rm models/Stable-diffusion/*safetensors
# mkdir -p /tmp/gradio models/ControlNet models/BLIP
# sed '/    start()/d' launch.py > tmp_prepare.py && \
# python3 tmp_prepare.py --skip-torch-cuda-test && \
# rm tmp_prepare.py
