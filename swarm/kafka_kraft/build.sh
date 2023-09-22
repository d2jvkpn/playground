#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

# set -x

kafka_version=3.5.1; [ $# -gt 0 ] && kafka_version=$1
scala_version=2.13

REGION=$(printenv REGION || true)

name=registry.cn-shanghai.aliyuncs.com/d2jvkpn/kafka
image=$name:$kafka_version

docker build --no-cache \
  --build-arg=SCALA_Version="$scala_version" \
  --build-arg=KAFKA_Version="$kafka_version" \
  --build-arg=REGION="$REGION" \
  -f ${_path}/Dockerfile -t $image ./

docker images -q -f dangling=true $name | xargs -i docker rmi {}

# echo "Push image: $image? (yes/no)"
# read -t 5 ans || true
# [ "$ans" != "yes" ] && exit 0

# DOCKER_Push=$(printenv DOCKER_Push || true)
DOCKER_Push=${DOCKER_Push:-"true")
[ "$DOCKER_Push" == "false" ] && exit 0
docker push $image
