#!/bin/bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

export HTTP_Port=$1

mkdir -p data/vocechat/data

envsubst < docker_deploy.yaml > docker-compose.yaml

exit
docker-compose up -d

docker cp vocechat:/home/vocechat-server/config data/vocechat/
