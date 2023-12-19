#! /usr/bin/env bash
set -eu -o pipefail

_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})
# set -x

export DEBIAN_FRONTEND=noninteractive
# export DEBIAN_FRONTEND=dialog
BUILD_Region=${BUILD_Region:-""}

[ -z $BUILD_Region ] || >&2 echo "==> BUILD_Region: $BUILD_Region"

[ -f ${_path}/${BUILD_Region}.debian.sh ] && bash ${_path}/${BUILD_Region}.debian.sh

apt update && \
  apt -y upgrade && \
  apt install -y --no-install-recommends \
    sudo tzdata pkg-config git wget vim netcat curl python3 python3-pip python3-venv && \
  apt -y remove && \
  apt -y autoremove && \
  apt -y clean && \
  apt -y autoclean && \
  dpkg -l | awk '/^rc/{print $2}' | xargs -i dpkg -P {} && \
  rm -rf /var/lib/apt/lists/*

[ -f ${_path}/${BUILD_Region}.pip.sh ] && bash ${_path}/${BUILD_Region}.pip.sh

mkdir -p venv && \
  python3 -m venv venv/ && \
  pip3 install --upgrade -r /app/bin/pip.txt && \
  rm -rf ~/.cache/pip
