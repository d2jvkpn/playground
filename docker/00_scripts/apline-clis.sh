#! /usr/bin/env sh
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})
# set -x

image_name="registry.cn-shanghai.aliyuncs.com/d2jvkpn/alpine"
image_tag="3"
image=$image_name:$image_tag

cp /etc/apk/repositories /etc/apk/repositories.bk && \
  sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories &&
  apk --no-cache update && apk --no-cache upgrade && apk --no-cache add tzdata gcompat curl

# sed -i 's/dl-cdn.alpinelinux.org/mirror.tuna.tsinghua.edu.cn/g' /etc/apk/repositories

docker pull alpine:$image_tag
echo ">>> building image: $image"

docker build --no-cache --squash -f ./Dockerfile -t "$image" .

docker push $image
docker images --filter=dangling=true --quiet $name | xargs -i docker rmi {}
