#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0)


if [ -d kylemanna_openvpn.git ]; then
    cd kylemanna_openvpn.git
    # git pull
else
    git clone https://github.com/kylemanna/docker-openvpn kylemanna_openvpn.git
    cd kylemanna_openvpn.git
fi

BUILD_Region=${BUILD_Region:-""}

docker build -f Dockerfile --no-cache -t kylemanna/openvpn:latest ./

cd ${_wd}

docker build -f ${_path}/Containerfile --no-cache \
  --build-arg=BUILD_Region="$BUILD_Region" \
  -t kylemanna/openvpn:local ./
