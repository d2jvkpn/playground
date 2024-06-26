#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

####
sudo apt install nvidia-driver-535
# reboot may be required
nvidia-smi

####
# pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
pip3 install torch==2.2.1 torchvision torchaudio -i https://pypi.tuna.tsinghua.edu.cn/simple 

pip3 show torch
# pip freeze
pip list | grep cuda

python3 -c 'from importlib.metadata import version; print("torch=="+version("torch"))'

python3 -c 'import torch; print(torch.cuda.is_available()); print(torch.cuda.get_device_name(0))'
