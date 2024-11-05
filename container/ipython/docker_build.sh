#!/bin/bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})
# set -x

image_tag=${1:-dev}
BUILD_Region=${BUILD_Region:-}

image_name=registry.cn-shanghai.aliyuncs.com/d2jvkpn/ipython
image=${image_name}:${image_tag}

docker pull ubuntu:22.04

docker build --no-cache -f ${_path}/Dockerfile \
  --build-arg=BUILD_Region="$BUILD_Region" \
  --tag $image ./

docker push $image
# docker images $image_name

docker images --filter "dangling=true" --quiet $image_name | xargs -i docker rmi {} || true
