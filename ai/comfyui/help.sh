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
