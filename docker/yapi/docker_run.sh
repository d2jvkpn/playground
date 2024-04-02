#!/bin/bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

####
HTTP_Port=$1; MONGO_Port=$2

docker pull registry.cn-hangzhou.aliyuncs.com/anoy/yapi
docker pull mongo:4

mkdir -p data/mongo

####
docker run --detach         \
  --name=yapi_mongo         \
  --restart=always          \
  --publish=${MONGO_Port}:27017     \
  --volume=$PWD/data/mongo:/data/db \
   mongo:7

docker run -it --rm        \
  --link yapi_mongo:mongo  \
  --entrypoint=npm         \
  --workdir=/api/vendors   \
  registry.cn-hangzhou.aliyuncs.com/anoy/yapi \
  run install-server

####
sleep 3

docker run --detach           \
  --name=yapi_web             \
  --restart=always            \
  --link yapi_mongo:mongo     \
  --publish=${HTTP_Port}:3000 \
  --workdir /api/vendors      \
  registry.cn-hangzhou.aliyuncs.com/anoy/yapi \
  server/app.js

# default:
#   username: admin@admin.com
#   password: ymfe.org
