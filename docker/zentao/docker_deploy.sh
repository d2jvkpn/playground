#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

HTTP_Port=${1:-3041}

mkdir -p data/mariadb data/zentao configs

db_root_password=$(tr -dc "0-9a-zA-Z" < /dev/urandom | fold -w 32 | head -n 1 || true)
db_user_password=$(tr -dc "0-9a-zA-Z" < /dev/urandom | fold -w 32 | head -n 1 || true)

[ -s configs/zentao.env ] || \
cat > configs/zentao.env <<EOF
MARIADB_ROOT_PASSWORD=$db_root_password
MARIADB_PASSWORD=$db_user_password
ZT_MYSQL_PASSWORD=$db_user_password
EOF

export HTTP_Port=$HTTP_Port USER_UID=$(id -u) USER_GID=$(id -g)
envsubst < docker_deploy.yaml > docker-compose.yaml

docker-compose pull

docker-compose up -d
