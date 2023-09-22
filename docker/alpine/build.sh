#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)/
_path=$(dirname $0)/

####
name="registry.cn-shanghai.aliyuncs.com/d2jvkpn/alpine"
tag="3"
image=$name:$tag

####
docker pull alpine:$tag
echo ">>> Building image: $image"
docker build --no-cache --squash -f ./Dockerfile -t "$image" .

####
docker push $image
docker images --filter=dangling=true --quiet $name | xargs -i docker rmi {}
