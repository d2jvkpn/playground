#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


mkdir -p data/gotify

docker-compose -f compose.template.yaml up -d

exit
# GOTIFY_SERVER_PORT=8030 ./gotify-linux-amd64
# default: { account: admin, password: admin }

curl "localhost:8030/message?token=AjX248in24F6Ejw" -F "title=A Test" -F "message=你好，世界！" -F "priority=10"
