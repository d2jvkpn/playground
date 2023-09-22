#! /usr/bin/env bash
set -eu -o pipefail

#### config and check
TAG="$1"
path=$(dirname $0)

docker pull golang:1.17-alpine
docker pull alpine

name="registry.cn-shanghai.aliyuncs.com/d2jvkpn/ntp"
image="$name:${TAG}"

#### build local image
echo ">>> Building image: $image"
docker build -f $path/Dockerfile --no-cache -t "$image" .

docker image prune --force --filter label=stage=ntp_builder

for img in $(docker images --filter=dangling=true --quiet $name); do
    docker rmi $img || true
done

#### push to registry
echo ">>> Pushing image: $image"
docker push $image
