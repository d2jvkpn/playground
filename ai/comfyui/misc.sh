#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit
python -c "import torch; print(torch.__version__)"

exit
apt-get install -y --no-install-recommends software-properties-common ca-certificates
add-apt-repository ppa:ubuntuhandbook1/ffmpeg8
apt-get update
apt-get install -y ffmpeg

exit
pip install --no-cache-dir -r custom_nodes/ComfyUI-Manager/requirements.txt
pip install --no-cache-dir xformers
pip install --no-cache-dir --no-build-isolation flash-attn



