#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


HTTP_Port=${1:-8090}
mkdir -p configs data/beszel

export USER_UID=$(id -u) USER_GID=$(id -g) \
  HTTP_Port=$HTTP_Port

envsubst < compose.template.yaml > compose.yaml

echo -e "\ncompose.yaml"
echo '```yaml'
cat compose.yaml
echo '```'

exit
docker-compose up -d
