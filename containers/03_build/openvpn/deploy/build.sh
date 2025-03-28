#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

if [ -d kylemanna_openvpn.git ]; then
    cd kylemanna_openvpn.git
    # git pull
else
    git clone https://github.com/kylemanna/docker-openvpn kylemanna_openvpn.git
    cd kylemanna_openvpn.git
fi

region=${region:-""}

docker build -f Dockerfile --no-cache -t kylemanna/openvpn:latest ./

cd ${_wd}

docker build --no-cache -f ${_path}/Containerfile \
  --build-arg=region="$region" \
  -t local/openvpn:dev ./
