#!//bin/bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

function display_usage() {
>&2 cat <<'EOF'
Usage of docker_deploy.sh(postgres):

help:
  ./docker_deploy.sh [help | -h | --help]

run:
  ./docker_deploy.sh run [DB_Port:-5432] [CONTAINER_Name:-postgres]
EOF
}

case "${1:-help}" in
"run")
    ;;
"help" | "-h" | "--help")
    display_usage
    exit 1
    ;;
"*")
    display_usage
    exit 1
    ;;
esac

export DB_Port=${2:-5432} CONTAINER_Name=${3:-postgres}

####
[ -s docker-compose.yaml ] && { >&2 echo "file exists: docker-compose.yaml"; exit 1; }

mkdir -p configs data/postgres

[ -s configs/postgres.password ] || \
  tr -dc 'a-zA-Z0-9' < /dev/urandom | fold -w 32 | head -n1 > configs/postgres.password || true

envsubst < ${_path}/docker_deploy.yaml > docker-compose.yaml

# docker-compose pull
docker-compose up -d

sleep 10
container=$(yq .services.postgres.container_name docker-compose.yaml)

docker exec -u postgres -w /var/lib/postgresql/data/ $container bash -c \
  "echo -e '\nlog_destination = jsonlog\nlogging_collector = on' >> postgresql.conf"

# sed -i 's/trust$/scram-sha-256/' pg_hba.conf

echo "==> restart postgres"
docker-compose down
docker-compose up -d

exit
container=$(yq .services.postgres.container_name docker-compose.yaml)
password=$(cat configs/postgres.password)

printf "$password\r\n" |
  docker exec -i -u postgres $container psql --username postgres --password

docker exec -it $container psql --username postgres -d postgres --password

docker exec -it --user postgres $container psql -d postgres --password

psql --host 127.0.0.1 --port 5432 --username postgres --password postgres
