#!/bin/bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

export DEBIAN_FRONTEND=noninteractive
# export DEBIAN_FRONTEND=dialog

BUILD_Region=${BUILD_Region:-""}

[ -z $BUILD_Region ] || >&2 echo "==> BUILD_Region: $BUILD_Region"

[ -f ${_path}/${BUILD_Region}.debian.sh ] && bash ${_path}/${BUILD_Region}.debian.sh

apt update && \
  apt -y upgrade && \
  apt install -y --no-install-recommends \
    sudo software-properties-common apt-transport-https ca-certificates tzdata locales \
    pkg-config lsb-release gnupg net-tools netcat net-tools \
    git vim jq file tree zip duf wget curl \
    python3 python3-pip python3-venv && \
  apt -y remove && \
  apt -y autoremove && \
  apt -y clean && \
  apt -y autoclean && \
  dpkg -l | awk '/^rc/{print $2}' | xargs -i dpkg -P {} && \
  rm -rf /var/lib/apt/lists/*

wget -O /usr/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
chmod a+x /usr/bin/yq

[ -f ${_path}/${BUILD_Region}.pip.sh ] && bash ${_path}/${BUILD_Region}.pip.sh

mkdir -p venv && \
  python3 -m venv venv/ && \
  source /app/venv/bin/activate && \
  pip3 install --upgrade -r /app/bin/pip.txt && \
  rm -rf ~/.cache/pip
