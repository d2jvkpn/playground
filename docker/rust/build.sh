#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

#### setup
name="registry.cn-shanghai.aliyuncs.com/d2jvkpn/rust"
tag="1-slim-buster"
image=$name:$tag

#### build
docker pull rust:$tag
docker build --no-cache --squash -f ./Dockerfile -t "$image" ./

#### push
docker push $image
docker images --filter=dangling=true --quiet $name | xargs -i docker rmi {}
