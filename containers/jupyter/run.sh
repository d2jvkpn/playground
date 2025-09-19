#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


image=local/jupyter:pytorch2.8.0-cuda12.9-cudnn9-runtime
py=python3.11

mkdir -p configs data/pip_packages logs

docker run -d --restart=always --name=jupyter --hostname=jupyter \
  --network=host --gpus=all \
  -v $(pwd):/home/appuser/work \
  -v $(pwd)/data/pip_packages:/home/appuser/.local/lib/$py/site-packages \
  --env-file=configs/container.env -e USER_UID=$(id -u) -e USER_GID=$(id -g) \
  -w /home/appuser/work \
  $image \
  jupyter lab --no-browser --ip=0.0.0.0 --port=8888

exit

1. configs/container.env
```text
JUPYTER_TOKEN=xxxxx
```
