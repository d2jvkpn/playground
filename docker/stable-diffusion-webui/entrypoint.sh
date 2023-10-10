#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

mkdir -p /tmp/gradio
python3 -m venv venv/

python3 launch.py $*

# --listen --api --port=7860
# -xformers --ckpt=models/Stable-diffusion/realisticVisionV13_v13.safetensors
# --nowebui --medvram --no-download-sd-model --skip-install
# --disable-safe-unpickle --no-download-sd-model

# address: http://localhost:7860/?__theme=dark
# curl http://localhost:7860
