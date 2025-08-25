#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit
docker build -f Containerfile --no-cache \
  -t local/jupyter:pytorch2.8.0-cuda12.9-cudnn9-runtime \
  ./

exit
mkdir -p configs data logs

docker run --name=jupyter -d --restart=always \
  --gpus=all -p 8888:8888 -v $(pwd):/root/work \
  --env-file=configs/container.env \
  local/jupyter:pytorch2.8.0-cuda12.9-cudnn9-runtime

exit
. .venv/bin/activate
. configs/local.env

export JUPYTER_TOKEN=$JUPYTER_TOKEN

jupyter lab --no-browser --allow-root --ip=0.0.0.0 --port=8888
