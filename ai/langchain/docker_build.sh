#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname $0`)

image=registry.cn-shanghai.aliyuncs.com/d2jvkpn/langchain
tag=latest

docker build -f ${_dir}/Dockerfile --tag $image:$tag ./

docker push $image:$tag
