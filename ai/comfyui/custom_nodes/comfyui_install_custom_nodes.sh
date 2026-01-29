#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


git clone --branch main --depth 1 --single-branch \
  https://github.com/crystian/ComfyUI-Crystools.git custom_nodes/ComfyUI-Crystools

pip install --no-cache-dir -r custom_nodes/ComfyUI-Crystools/requirements.txt

git clone --branch main --depth 1 --single-branch \
  https://github.com/Comfy-Org/ComfyUI-Manager.git custom_nodes/ComfyUI-Manager

pip install --no-cache-dir -r custom_nodes/ComfyUI-Manager/requirements.txt

mv custom_nodes/ComfyUI-Manager custom_nodes/ComfyUI-Manager.disabled
