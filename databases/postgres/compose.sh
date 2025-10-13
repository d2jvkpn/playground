#!//bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

function display_usage() {
>&2 cat <<'EOF'
Usage of docker_deploy.sh(postgres):

help:
  ./compose.sh [help | -h | --help]

run:
  ./compose.sh run [DB_Port:-5432] [CONTAINER_Name:-postgres]
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
[ -s compose.yaml ] && { >&2 echo "file already exists: compose.yaml"; exit 1; }

mkdir -p configs data/postgres
# data/postgres/backups/wal_archive data/temp

[ -s configs/postgres.pass ] || \
  tr -dc 'a-zA-Z0-9' < /dev/urandom | fold -w 32 | head -n1 > configs/postgres.pass || true

envsubst < ${_path}/compose.template.yaml > compose.yaml

exit
# docker-compose pull
docker-compose up -d

docker exec postgres bash -c "chown -R postgres:postgres backups"

#### config
# container=$(yq .services.postgres.container_name docker-compose.yaml)

# docker exec -u postgres -w /var/lib/postgresql/data/ $container bash -c \
#   "echo -e '\nlog_destination = jsonlog\nlogging_collector = on' >> postgresql.conf"

# sed -i 's/trust$/scram-sha-256/' pg_hba.conf

####
exit
container=$(yq .services.postgres.container_name docker-compose.yaml)
password=$(cat configs/postgres.pass)

printf "$password\r\n" |
  docker exec -i -u postgres $container psql --username postgres --password

docker exec -it $container psql --username postgres -d postgres --password
docker exec -it --user postgres $container psql -d postgres --password
psql --host 127.0.0.1 --port 5432 --username postgres --password postgres

#### add user hello
exit
username=hello

docker exec -it postgres createuser --username=postgres $username --createdb --login
docker exec -it postgres psql --username=postgres -c "create database $username owner=$username"
# docker exec -it postgres psql --username=postgres -c 'grant all privileges on database hello to hello'
# docker exec -it postgres psql --username=postgres -c "ALTER ROLE hello PASSWORD 'world'"
docker exec -it postgres psql --username=postgres -c "\password $username"

docker exec -it postgres psql --username=$username

#### remove secret from config
docker-compose down

sed -i -e '/postgres\.pass/d' -e '/POSTGRES_PASSWORD_FILE/d' docker-compose.yaml

docker-compose up -d
