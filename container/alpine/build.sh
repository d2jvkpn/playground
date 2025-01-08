#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

#### 1. 
app_name=alpine
region=${region:-""}
DOCKER_Push=${DOCKER_Push:-true}

image_name=${1:-registry.cn-shanghai.aliyuncs.com/d2jvkpn/alpine}
image_tag=${2:-3}

image=$image_name:$image_tag

#### 2. 
# docker pull alpine:3

docker build --no-cache \
  --build-arg=APP_Name=$app_name \
  --build-arg=APP_Version=$image_tag \
  --build-arg=region="$region" \
  -f ${_path}/Containerfile -t $image ./

####
# echo "Push image: $image? (yes/no)"
# read -t 5 ans || true
# [ "$ans" != "yes" ] && exit 0

# DOCKER_Push=$(printenv DOCKER_Push || true)
[ "$DOCKER_Push" != "false" ] && docker push $image

docker images -q -f dangling=true $image_name | xargs -i docker rmi {}

for img in $(docker images --filter=dangling=true --filter=label=app=$app_name --quiet); do
    >&2 echo "==> remove image: $img"
    docker rmi $img || true
done
