#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


mkdir -p configs/certs data/es data/kibana

if [ ! -s configs/certs/es.pass ]; then
    password=$(tr -dc '0-9a-zA-Z' < /dev/urandom | fold -w 32 | head -n1 || true)
    echo "$password" > configs/certs/es.pass
fi

docker run --rm \
  -v $PWD/configs/certs:/usr/share/elasticsearch/config/certs \
  docker.elastic.co/elasticsearch/elasticsearch:8.17.0 \
  bash -c "chown -R elasticsearch:root config/certs && chmod 600 config/certs/es.pass"

password=$(cat configs/certs/es.pass)
{
    echo "username: elastic"
    echo "password: $password"
    echo "ca: "
} > configs/es.yaml

docker-compose -f compose.es.yaml up -d

####
exit
docker run --name es -d -m 2GB -p 9200:9200 \
  -e discovery.type=single-node \
  docker.elastic.co/elasticsearch/elasticsearch:8.17.0
