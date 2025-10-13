#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


#### 1. 
image=local/jupyter:pytorch2.8.0-cuda12.9-cudnn9-runtime
py=python3.11

mkdir -p configs data/pip logs

#### 2. 
length=${1:-32}
if [ -s "configs/container.env"  ]; then
    token=$(tr -dc '0-9a-z' < /dev/urandom | fold -w $length | head -n 1 || true)

    echo "JUPYTER_TOKEN=$token" > configs/container.env
fi

#### 3. 
docker run -d --restart=always --name=jupyter --hostname=jupyter \
  --network=host --gpus=all \
  -v $(pwd):/home/appuser/workspace \
  -v $(pwd)/data/pip:/home/appuser/.local/lib/$py/site-packages \
  --env-file=configs/container.env -e USER_UID=$(id -u) -e USER_GID=$(id -g) \
  -w /home/appuser/workspace \
  $image \
  jupyter lab --no-browser --ip=0.0.0.0 --port=8888

####
exit
conda install cuda-nvcc -c nvidia
pip install flash-attn
