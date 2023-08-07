#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

apt update && apt -y upgrade

DEBIAN_FRONTEND=noninteractive apt install -y tzdata pkg-config $*

apt remove && apt autoremove && apt clean && apt autoclean
dpkg -l | awk '/^rc/{print $2}' | xargs -i dpkg -P {}
rm -rf /var/lib/apt/lists/*
