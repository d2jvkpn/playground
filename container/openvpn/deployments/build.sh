#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

if [ -d kylemanna_openvpn.git ]; then
    cd kylemanna_openvpn.git
    # git pull
else
    git clone https://github.com/kylemanna/docker-openvpn kylemanna_openvpn.git
    cd kylemanna_openvpn.git
fi

docker build -f Dockerfile -t kylemanna/openvpn:local ./

cd ${_wd}
docker build --no-cache -f ${_path}/Containerfile -t kylemanna/openvpn:local ./
