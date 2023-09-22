#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

#### docker run
docker run -d --restart=always -p 3000:3000 --name vocechat_app privoce/vocechat-server:latest

#### copy default config from container
docker run --rm -it --name=vocechat_tmp privoce/vocechat-server:latest sh
docker cp vocechat_tmp:/home/vocechat-server/config ./

#### docker-compose
export PORT=2000
envsubst < deploy.yaml > docker-compose.yaml
docker-compose up -d
