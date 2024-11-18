#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

git clone https://github.com/kylemanna/docker-openvpn kylemanna_openvpn.git

cd kylemanna_openvpn.git

docker build -f Dockerfile -t local/kylemanna/openvpn .
