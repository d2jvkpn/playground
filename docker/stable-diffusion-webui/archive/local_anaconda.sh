#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})


####
mkdir -p ~/.pip/

cat > ~/.pip/pip.conf <<EOF
[global]
index-url = https://pypi.douban.com/simple/

[install]
trusted-host = pypi.douban/simple
EOF

# pip3 install conda

####
output=Anaconda3-$(date +%Y-%m-%d)-Linux-x86_64.sh
curl --output $output  https://repo.anaconda.com/archive/Anaconda3-2023.03-Linux-x86_64.sh
# https://repo.anaconda.com/archive/Anaconda3-5.3.1-Linux-x86_64.sh

bash $output -b -p ~/apps/anaconda3

export PATH=~/apps/anaconda3/bin:$PATH

conda init bash

####
git clone https://github.com/CompVis/stable-diffusion
cd stable-diffusion

conda env create -f environment.yaml
conda env update -f environment.yaml


conda activate ldm
python scripts/txt2img.py --prompt "a photograph of an astronaut riding a horse" --plms
