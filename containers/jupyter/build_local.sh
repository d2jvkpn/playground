#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


docker pull ubuntu:24.04

mkdir -p workspace

# --depth 1 
git clone --branch main --single-branch https://github.com/pytorch/pytorch workspace/pytorch.git

cd workspace/pytorch.git

# avoid docker build error
sed '/^COPY/s#\.$#\./#' Dockerfile > Containerfile

nohup docker build \
  --build-arg=BASE_IMAGE=ubuntu:24.04 \
  --build-arg=PYTHON_VERSION=3.12 \
  --build-arg=INSTALL_CHANNEL=whl \
  --build-arg=PYTORCH_VERSION=2.9.0 \
  --build-arg=CUDA_VERSION=13.0 \
  --build-arg=CUDA_PATH=cu130 \
  -f Containerfile \
  -t local/pytorch:2.9.0-cuda13.0-cudnn9-runtime ./ &

# rm Containerfile nohup.out
# git pull
