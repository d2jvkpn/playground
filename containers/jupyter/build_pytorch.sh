#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


PYTORCH_VERSION=2.8.0 # 2.9.0
CUDA_VERSION=12.9     # 13.0
CUDA_PATH=cu$(echo $CUDA_VERSION | sed 's#\.##')

docker pull ubuntu:24.04

mkdir -p data
rm -rf data/pytorch.git

git clone --branch main --depth 1 --single-branch \
  https://github.com/pytorch/pytorch data/pytorch.git

cd data/pytorch.git

# avoid docker build error
sed "/^COPY/s#\.\$#\./#; /pip install.*torchaudio/s/torch /torch==$PYTORCH_VERSION /" \
  Dockerfile > Containerfile

# https://github.com/Dao-AILab/flash-attention/releases

docker build \
  --build-arg=BASE_IMAGE=ubuntu:24.04 \
  --build-arg=PYTHON_VERSION=3.12 \
  --build-arg=INSTALL_CHANNEL=whl \
  --build-arg=PYTORCH_VERSION=$PYTORCH_VERSION \
  --build-arg=CUDA_VERSION=$CUDA_VERSION \
  --build-arg=CUDA_PATH=$CUDA_PATH \
  -f Containerfile \
  -t local/pytorch:${PYTORCH_VERSION}-cuda${CUDA_VERSION}-cudnn9-runtime ./

rm -f Containerfile

# rm Containerfile nohup.out
# git pull
