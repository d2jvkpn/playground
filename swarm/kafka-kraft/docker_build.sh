#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

# set -x
KAFKA_Version=${KAFKA_Version:-3.6.1}
SCALA_Version=${SCALA_Version:-2.13}

BUILD_Region=$(printenv BUILD_Region || true)

name=registry.cn-shanghai.aliyuncs.com/d2jvkpn/kafka
image=$name:$KAFKA_Version

docker pull alpine:3

docker build --no-cache \
  --build-arg=SCALA_Version="$SCALA_Version" \
  --build-arg=KAFKA_Version="$KAFKA_Version" \
  --build-arg=BUILD_Region="$BUILD_Region" \
  -f ${_path}/Dockerfile -t $image ./

docker images -q -f dangling=true $name | xargs -i docker rmi {}

# echo "Push image: $image? (yes/no)"
# read -t 5 ans || true
# [ "$ans" != "yes" ] && exit 0

# DOCKER_Push=$(printenv DOCKER_Push || true)
DOCKER_Push=${DOCKER_Push:-"true"}
[ "$DOCKER_Push" == "false" ] && exit 0
docker push $image
