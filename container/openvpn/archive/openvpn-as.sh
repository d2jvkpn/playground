#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

# https://openvpn.net/as-docs/docker.html#run-the-docker-container

docker run -d \
  --name=openvpn-as --cap-add=NET_ADMIN \
  -p 943:943 -p 443:443 -p 1195:1195/udp \
  -v $PWD/data/openvpn-as:/openvpn \
  openvpn/openvpn-as:latest

docker logs -f openvpn-as | grep "Auto-generated pass"
