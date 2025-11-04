#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


mkdir -p data

# --depth 1 
git clone --branch main --single-branch https://github.com/pytorch/pytorch data/pytorch.main.git

cd data/pytorch.main.git

docker build \
  --build-arg=BASE_IMAGE=ubuntu:24.04 \
  --build-arg=PYTHON_VERSION=3.12 \
  -f Dockerfile -t local/pytorch:latest \
  ./
