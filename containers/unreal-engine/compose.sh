#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(readlink -f `dirname $0`)


APP_Name=$1
WS_Url=$2

export USER_UID=$(id -u) \
  USE_GID=$(id -g) \
  APP_Name="$APP_Name" \
  WS_Url="$WS_Url"

envsubst < compose.ue5.yaml > compose.yaml


exit
docker-compose pull
docker-compose up -d
