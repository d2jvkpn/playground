#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


echo "pytorch2.8.0 cuda12.9"

exit
conda install cuda-nvcc -c nvidia

exit
pip install flash-attn --no-build-isolation

exit
git clone --depth 1 https://github.com/Dao-AILab/flash-attention flash-attention.git
cd flash-attention.git
python setup.py install
