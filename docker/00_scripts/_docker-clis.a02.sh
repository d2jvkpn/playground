#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

####
docker build --no-cache --squash -f ./Dockerfile -t "$image" ./

# --arg value "abc"
jq '. + {experimental: true}' /etc/docker/daemon.json > daemon.json

sudo cp daemon.json /etc/docker/daemon.json

sudo systemctl restart docker

####
pip3 install docker-squash
docker-squash $image

docker system prune -a

docker system df
