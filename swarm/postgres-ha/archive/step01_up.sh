#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

mkdir -p data/{node01,node02,node03}
sudo chown 70:70 data/{node01,node02,node03}
sudo chmod 0750 data/{node01,node02,node03}

ls scripts/{config_primary.sh,config_replica.sh,run.sh} \
  configs/node{01..03}.env &> /dev/null

if [ ! -s configs/secret_postgres.txt ]; then
    tr -dc '0-9a-zA-Z._\-' < /dev/urandom |
      fold -w 32 |
      head -n 1 > configs/secret_postgres.txt || true
fi

if [ ! -s configs/secret_replicator.txt ]; then
    tr -dc '0-9a-zA-Z._\-' < /dev/urandom |
      fold -w 32 |
      head -n 1 > configs/secret_replicator.txt || true
fi

cp docker_deploy.yaml docker-compose.yaml
docker-compose up -d
docker-compose logs

sleep 5

while ! nc -z localhost 5441; do
    echo "~~~ node01 isn't ready"
    sleep 1 && echo -n .
done

echo "==> set postgres password"
# docker exec -it -u postgres postgres-node01 psql -c '\password'
password=$(awk '{print $1; exit}' configs/secret_postgres.txt)

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
