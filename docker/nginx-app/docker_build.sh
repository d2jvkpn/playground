#!/bin/bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

name=registry.cn-shanghai.aliyuncs.com/d2jvkpn/nginx-app:latest

docker build --no-cache -f ${_path}/Dockerfile -t $name ./
docker push $name
