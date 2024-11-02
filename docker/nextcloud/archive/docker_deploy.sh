#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

HTTP_Port=${1:-3031}; dry_run=${dry_run:-false}

mkdir -p data/nextcloud data/postgres configs

password=$(tr -dc "0-9a-zA-Z" < /dev/urandom | fold -w 32 | head -n 1 || true)

[ -s configs/nextcloud.env ] || \
cat > configs/nextcloud.env <<EOF
POSTGRES_PASSWORD=$password
EOF

export HTTP_Port=$HTTP_Port USER_UID=$(id -u) USER_GID=$(id -g)
envsubst < docker_deploy.postgres.yaml > docker-compose.yaml

[ "$dry_run" == "true" ] && exit 0

docker-compose up -d
sleep 5
docker-compose logs

exit

sed -i 's/  env_file/  # env_file/' docker-compose.yaml
