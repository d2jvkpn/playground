#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


sudo apt update
sudo apt install git git-lfs
git lfs install

git clone https://huggingface.co/BAAI/bge-m3
