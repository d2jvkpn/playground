#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


#### 1. load and init
image=local/jupyter:pytorch2.9.0-cuda13.0-cudnn9-runtime
py=python3.12

mkdir -p configs data/pip logs

#### 2. generate configs/container.env
length=${1:-32}
if [ -s "configs/container.env"  ]; then
    token=$(tr -dc '0-9a-z' < /dev/urandom | fold -w $length | head -n 1 || true)

    echo "JUPYTER_TOKEN=$token" > configs/container.env
fi

#### 3. run
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
# -v $(pwd)/configs/pip.conf:/home/appuser/.config/pip/pip.conf
# -v $(pwd)/configs/ipython_config.py:/home/appuser/.ipython/profile_default/ipython_config.py
# -e PATH=/home/appuser/workspace/data/pip/bin:/opt/conda/bin:$PATH
# -e PYTHONPATH=/home/appuser/workspace/data/pip:/opt/conda/lib/$(py)/site-packages

exit
conda install cuda-nvcc -c nvidia
pip install flash-attn
