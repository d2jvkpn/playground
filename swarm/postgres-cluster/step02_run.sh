#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

action=$1

case "$action" in
up)
    echo "==> docker-compose up"
    cp docker_deploy.yaml docker-compose.yaml
    docker-compose up -d
    docker-compose logs
    ;;
down)
    echo "==> docker-compose down"
    docker-compose down

    echo '!!! Remove files in data?(yes/no)'
    read -t 5 ans || true
    [ "$ans" != "yes" ] && exit 0

    sudo rm -rf data/postgres-node{01..04}
    ;;
*)
    >&2 echo "unknown action: $action"
    exit 1
    ;;
esac

exit

####
while ! nc -z localhost 5441; do
    echo "~~~ postgres-node01 isn't ready"
    sleep 1 && echo -n .
done

echo "==> set postgres password"
# docker exec -it -u postgres postgres-node01 psql -c '\password'
password=$(awk '{print $1; exit}' configs/postgres.password)

docker exec -u postgres postgres-node01 psql \
  -c "alter user postgres with encrypted password '$password';"
# \password postgres

exit
#### when primary node: node01 is ready
while true; do
    exists=$(docker exec -u postgres postgres-node01 psql \
      -c "SELECT 1 FROM pg_roles WHERE rolname='replicator'" | grep -c "1 row" || true)

    [ $exists -eq 0 ] && { echo "~~~ role replicator doesn't exist"; sleep 1; continue; };
    break
done
