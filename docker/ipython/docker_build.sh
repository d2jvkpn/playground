#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

tag=dev; [ $# -gt 0 ] && tag=$1
image=registry.cn-shanghai.aliyuncs.com/d2jvkpn/ipython

REGION=$(printenv REGION || true)

docker pull ubuntu:22.04

docker build --no-cache -f ${_path}/Dockerfile \
  --build-arg=REGION="$REGION" \
  --tag $image:$tag ./

docker push $image:$tag
docker images $image

for img in $(docker images --filter "dangling=true" --quiet $image); do
    docker rmi $img || true
done &> /dev/null
