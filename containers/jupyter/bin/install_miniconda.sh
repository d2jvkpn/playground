#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


py_version=$1

wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh

bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/conda && \

rm -f Miniconda3-latest-Linux-x86_64.sh && \
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r
conda install python="$py_version" -y --quiet
conda clean -afy

#conda init bash # activate conda base env by default
#conda create -n myenv python=3.14 -y
#conda run -n myenv python script.py
#conda install pip
#conda env export > environment.yml
