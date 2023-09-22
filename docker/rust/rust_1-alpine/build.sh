#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)/
_path=$(dirname $0)/

#### setup
name="registry.cn-shanghai.aliyuncs.com/d2jvkpn/rust"
tag="1-alpine"
image=$name:$tag

#### build
docker pull rust:$tag
echo ">>> Building image: $image"
docker build --no-cache --squash -f ./Dockerfile -t "$image" ./

#### push
docker push $image
docker images --filter=dangling=true --quiet $name | xargs -i docker rmi {}
