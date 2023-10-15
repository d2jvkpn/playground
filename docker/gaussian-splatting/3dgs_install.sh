#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

####
export DEBIAN_FRONTEND=nointeractive
export TZ=Asia/Shanghai
export CONDA_HOME=/opt/conda
export PATH=/opt/gaussian-splatting/SIBR_viewers/install/bin:$CONDA_HOME/bin:$PATH

apt update && \
  apt -y upgrade && \
  apt install -y git wget zip colmap imagemagick && \
  apt install -y cmake libglew-dev libassimp-dev libboost-all-dev libgtk-3-dev libopencv-dev \
    libglfw3-dev libavdevice-dev libavcodec-dev libeigen3-dev libxxf86vm-dev libembree-dev && \
  apt clean && \
  rm -rf /var/lib/apt/lists/*

wget -qO ninja.gz \
  https://github.com/ninja-build/ninja/releases/latest/download/ninja-linux.zip && \
  unzip ninja.gz -d /usr/local/bin/ && \
  chmod a+x /usr/local/bin/ninja && \
  rm ninja.gz && \
  ninja --version

# https://docs.conda.io/projects/conda/en/latest/user-guide/install/linux.html
# wget https://repo.anaconda.com/archive/Anaconda3-2023.09-0-Linux-x86_64.sh
# bash Anaconda3-2023.09-0-Linux-x86_64.sh -b -p /opt/conda

wget -qO miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
  /bin/bash miniconda.sh -b -p /opt/conda && \
  rm miniconda.sh

####
git clone https://github.com/graphdeco-inria/gaussian-splatting --recursive /opt/gaussian-splatting

cd /opt/gaussian-splatting/SIBR_viewers && \
  cmake -Bbuild -G Ninja . -DCMAKE_BUILD_TYPE=Release && \
  cmake --build build -j24 --target install && \
  rm -rf build

conda env create --file /opt/gaussian-splatting/environment.yml
conda clean --all --yes
