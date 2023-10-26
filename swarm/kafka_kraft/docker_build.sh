#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

# set -x
KAFKA_Version=${1:-3.6.0}
SCALA_Version=2.13

REGION=$(printenv REGION || true)

name=registry.cn-shanghai.aliyuncs.com/d2jvkpn/kafka
image=$name:$KAFKA_Version

docker build --no-cache \
  --build-arg=SCALA_Version="$SCALA_Version" \
  --build-arg=KAFKA_Version="$KAFKA_Version" \
  --build-arg=REGION="$REGION" \
  -f ${_path}/Dockerfile -t $image ./

docker images -q -f dangling=true $name | xargs -i docker rmi {}

# echo "Push image: $image? (yes/no)"
# read -t 5 ans || true
# [ "$ans" != "yes" ] && exit 0

# DOCKER_Push=$(printenv DOCKER_Push || true)
DOCKER_Push=${DOCKER_Push:-"true"}
[ "$DOCKER_Push" == "false" ] && exit 0
docker push $image
