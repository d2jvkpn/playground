#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


export HTTP_Port=${1:-3000}

mkdir -p data/vocechat-server

envsubst < compose.vocechat.yaml > compose.yaml

exit
docker-compose up -d

docker cp vocechat:/home/vocechat-server/config data/vocechat/
