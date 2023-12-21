#! /usr/bin/env bash
set -eu -o pipefail

_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})
# set -x

UserID=$(id -u)
GroupID=$(id -g)

mkdir -p data

docker run -d --name ipython -v $PWD/data:/app/data \
  --user ${UserID}:${GroupID} -v GroupID=${GroupID} \
  registry.cn-shanghai.aliyuncs.com/d2jvkpn/ipython:dev sleep infinity
