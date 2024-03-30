#! /usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

HTTP_Port=${1:-3011}
SSH_Port=${1:-3012}
Network=${Network:-local}

mkdir -p data/gitea data/postgres configs
password=$(tr -dc "0-9a-zA-Z" < /dev/urandom | fold -w 32 | head -n 1 || true)

[ -s configs/gitea.env ] || \
cat > configs/gitea.env <<EOF
GITEA__database__PASSWD=$password
POSTGRES_PASSWORD=$password
EOF

export Network=${Network} HTTP_Port=$HTTP_Port SSH_Port=$SSH_Port
export USER_UID=$(id -u) USER_GID=$(id -g)

envsubst < docker_postgres.yaml > docker-compose.yaml

docker-compose up -d
sleep 5
docker-compose logs
