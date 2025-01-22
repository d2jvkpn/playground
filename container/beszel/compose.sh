#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


mkdir -p configs data/beszel

export USER_UID=$(id -u) USER_GID=$(id -g)

envsubst < compose.template.yaml > compose.yaml

exit
docker-compose up -d
