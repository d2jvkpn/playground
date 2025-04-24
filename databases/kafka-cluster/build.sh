#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


region=${region:-""}
SCALA_Version=${SCALA_Version:-2.13}
KAFKA_Version=${KAFKA_Version:-4.0.0}
DOCKER_Push=${DOCKER_Push:-"true"}

# name=registry.cn-shanghai.aliyuncs.com/d2jvkpn/kafka
name=local/kafka
image=$name:$KAFKA_Version

mkdir -p cache

####
#docker pull alpine:3
docker pull alpine/java:21-jre

DOCKER_BUILDKIT=1 docker build --no-cache \
  --build-arg=region="$region" \
  --build-arg=KAFKA_Version="$KAFKA_Version" \
  --build-arg=SCALA_Version="$SCALA_Version" \
  -f ${_dir}/Containerfile -t $image ./

# echo "Push image: $image? (yes/no)"
# read -t 5 ans || true
# [ "$ans" != "yes" ] && exit 0

docker images -q -f dangling=true $name | xargs -i docker rmi {}
for img in $(docker images --filter=dangling=true --filter=label=app=kafka --quiet); do
    >&2 echo "==> remove image: $img"
    docker rmi $img || true
done

exit
# DOCKER_Push=$(printenv DOCKER_Push || true)
[ "$DOCKER_Push" != "false" ] && docker push $image
