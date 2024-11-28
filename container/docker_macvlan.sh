#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

device=$(ip route | awk '/^default/{print $5}')

docker network create -d macvlan \
  --subnet=192.168.1.0/24 \
  --gateway=192.168.1.1 \
  -o parent=$device macvlan


docker run --network=macvlan --name http-server -d  python:3-alpine python3 -m http.server 8000
