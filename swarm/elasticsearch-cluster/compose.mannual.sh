#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


#### 1. prepare
mkdir -p configs

docker network create elastic

# sysctl -w vm.max_map_count=262144
{
    docker run --rm docker.elastic.co/elasticsearch/elasticsearch:8.17.0 cat /etc/sysctl.conf
    echo "vm.max_map_count=262144"
} > configs/sysctl.conf

docker run --name es01 --net elastic -p 9200:9200 -it -m 2GB \
  -v $PWD/configs/sysctl.conf:/etc/sysctl.conf \
  docker.elastic.co/elasticsearch/elasticsearch:8.17.0

#### 2. create es01
docker exec -it es01 \
  bash -c "printf 'y' | elasticsearch-reset-password -u elastic" |
  awk '/New value/{print $NF}' |
  dos2unix > configs/elastic.pass

docker exec -it es01 \
  elasticsearch-create-enrollment-token -s kibana |
  dos2unix > configs/kibana.pass

docker exec -it es01 \
  elasticsearch-create-enrollment-token -s node |
  dos2unix > configs/node.pass

docker cp es01:/usr/share/elasticsearch/config/certs/http_ca.crt configs/

#### 3. tests
auth="--cacert configs/http_ca.crt -u elastic:$(cat configs/elastic.pass)"
addr="https://localhost:9200"

curl $auth $addr

curl $auth -X PUT "$addr/idx"

curl $auth "$addr/_cat/indices?v"

curl $auth -X POST "$addr/idx/_doc/1" \
  -H 'Content-Type: application/json' \
  -d'{"title": "Test Document","content": "This is a test document."}'
  

curl $auth  "$addr/idx/_search?q=content:test"

#### 4. add node es02
docker run --name es02 --net elastic -it -m 2GB \
  -v $PWD/configs/sysctl.conf:/etc/sysctl.conf \
  -e ENROLLMENT_TOKEN="$(cat configs/node.pass)" \
  docker.elastic.co/elasticsearch/elasticsearch:8.17.0

curl $auth $addr/_cat/nodes

#### 5. add kibana
docker run --name kibana --net elastic -p 5601:5601 docker.elastic.co/kibana/kibana:8.17.0

# docker logs kibana | grep "Your verification code is:"
