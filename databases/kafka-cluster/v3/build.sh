#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

region=${region:-}
KAFKA_Version=${KAFKA_Version:-3.9.0}
SCALA_Version=${SCALA_Version:-2.13}
DOCKER_Push=${DOCKER_Push:-"true"}

name=registry.cn-shanghai.aliyuncs.com/d2jvkpn/kafka
image=$name:$KAFKA_Version

####
docker pull alpine:3

docker build --no-cache \
  --build-arg=region="$region" \
  --build-arg=KAFKA_Version="$KAFKA_Version" \
  --build-arg=SCALA_Version="$SCALA_Version" \
  -f ${_path}/Containerfile -t $image ./

# echo "Push image: $image? (yes/no)"
# read -t 5 ans || true
# [ "$ans" != "yes" ] && exit 0

# DOCKER_Push=$(printenv DOCKER_Push || true)
[ "$DOCKER_Push" != "false" ] && docker push $image

docker images -q -f dangling=true $name | xargs -i docker rmi {}
for img in $(docker images --filter=dangling=true --filter=label=app=kafka --quiet); do
    >&2 echo "==> remove image: $img"
    docker rmi $img || true
done
