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

docker run -t --rm -v /var/run/docker.sock:/var/run/docker.sock:ro pegleg/whaler \
  -sV=1.36 nginx:latest

exit
docker build --network=host -f Containerfile -t name:tag ./
