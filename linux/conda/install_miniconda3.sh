#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


mkdir -p downloads

curl -o downloads/Miniconda3-latest-Linux-x86_64.sh \
  https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh


bash downloads/Miniconda3-latest-Linux-x86_64.sh -b -p /opt/miniconda3
# /opt/miniconda3/bin/conda init --reverse $SHELL

exit
conda search python
conda search --full-name python

/opt/miniconda3/bin/conda create --name python3.9 python=3.9

/opt/miniconda3/bin/conda create -n py3.9 python=3.9

ls /opt/miniconda3/py3.9/bin/python

conda env list
conda info --envs
conda activate py3.9
conda deactivate
