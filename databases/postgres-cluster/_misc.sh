#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

exit
echo "==> docker-compose up"
docker-compose up -d
docker-compose logs

exit
echo "==> docker-compose down"
docker-compose down

echo '!!! Remove files in data?(yes/no)'
read -t 5 ans || true
[ "$ans" != "yes" ] && exit 0

sudo rm -rf data/postgres-node{01..04}

####
while ! nc -z localhost 5441; do
    echo "~~~ postgres-node01 isn't ready"
    sleep 1 && echo -n .
done

echo "==> set postgres password"
# docker exec -it -u postgres postgres-node01 psql -c '\password'
password=$(awk '{print $1; exit}' configs/postgres.pass)

docker exec -u postgres postgres-node01 psql \
  -c "alter user postgres with encrypted password '$password';"
# \password postgres

exit
docker exec -it -u postgres postgres-node01 psql -x -c '\password postgres'

exit
#### when primary node: node01 is ready
while true; do
    exists=$(docker exec -u postgres postgres-node01 psql \
      -c "SELECT 1 FROM pg_roles WHERE rolname='replicator'" | grep -c "1 row" || true)

    [ $exists -eq 0 ] && { echo "~~~ role replicator doesn't exist"; sleep 1; continue; };
    break
done
