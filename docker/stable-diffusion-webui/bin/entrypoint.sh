#!/bin/bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

# path: /app/bin/entrypoint.sh

mkdir -p /tmp/gradio
source venv/bin/activate

python3 launch.py "$@"

# --listen --api --port=7860
# -xformers --ckpt=models/Stable-diffusion/realisticVisionV13_v13.safetensors
# --nowebui --medvram --no-download-sd-model --skip-install --disable-safe-unpickle

# address: http://localhost:7860/?__theme=dark
# curl http://localhost:7860
