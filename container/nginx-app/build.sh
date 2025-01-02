#!/bin/bash
set -eu -o pipefaill _wd=$(pwd); _path=$(dirname $0)

name=registry.cn-shanghai.aliyuncs.com/d2jvkpn/nginx-app:latest

docker build --no-cache -f ${_path}/Containerfile -t $name ./
docker push $name
