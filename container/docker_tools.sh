#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})


exit

pip3 install runlike
pip3 install whaler

docker ps | awk 'NR>1{print $NF}' | xargs -i runlike {}

exit
mkdir configs
ln -sr company.docker-aliyun.json configs/config.json

docker --config ./configs pull your_image

exit

docker ps |
  awk 'NR>1{print $NF}' |
  xargs -i docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  assaflavie/runlike {}

exit
device=$(ip route | awk '/^default/{print $5}')

docker network create -d macvlan \
  --subnet=192.168.1.0/24 \
  --gateway=192.168.1.1 \
  -o parent=$device macvlan


docker run --network=macvlan --name http-server -d  python:3-alpine python3 -m http.server 8000

docker build --network=host -f Containerfile -t name:tag ./
