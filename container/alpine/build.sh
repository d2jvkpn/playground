#!/bin/bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

# set -x
BUILD_Region=${BUILD_Region:-cn}
DOCKER_Push=${DOCKER_Push:-true}
BUILD_Time=$(date +'%FT%T%:z')

image_name=registry.cn-shanghai.aliyuncs.com/d2jvkpn/alpine
image_tag=3

image=$image_name:$image_tag

####
# docker pull alpine:3

docker build --no-cache \
  --build-arg=BUILD_Region="$BUILD_Region" \
  --build-arg=BUILD_Time="$BUILD_Time" \
  -f ${_path}/Containerfile -t $image ./

####
docker images -q -f dangling=true $image_name | xargs -i docker rmi {}

# echo "Push image: $image? (yes/no)"
# read -t 5 ans || true
# [ "$ans" != "yes" ] && exit 0

# DOCKER_Push=$(printenv DOCKER_Push || true)
[ "$DOCKER_Push" == "false" ] && exit 0
docker push $image
