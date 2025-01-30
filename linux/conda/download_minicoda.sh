#!/usr/bin/env bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


# curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh

mkdir -p data/downloads

curl -o data/downloads/Miniconda3-latest-Linux-x86_64.sh \
  https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh


exit

bash data/downloads/Miniconda3-latest-Linux-x86_64.sh

conda init --reverse $SHELL
# /opt/miniconda3/bin/conda
