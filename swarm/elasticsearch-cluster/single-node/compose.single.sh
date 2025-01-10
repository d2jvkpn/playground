#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


mkdir -p configs/es data/es

sudo chown -R 1000:0 configs/es data/es

docker run --name es -d -m 2GB -p 9200:9200 \
  -e discovery.type=single-node \
  docker.elastic.co/elasticsearch/elasticsearch:8.17.0

until curl -k  https://localhost:9200 | grep -q 'missing authentication credentials'; do
    sleep 3
done

docker cp es:

docker-compose -f compose.single.yaml up -d

sudo chown 1000:0 configs/certs data/es

####
docker exec -it es \
  bash -c "printf 'y' | elasticsearch-reset-password -u elastic" |
  awk '/New value/{print $NF}' |
  dos2unix > configs/elastic.pass

auth="--cacert configs/http_ca.crt -u elastic:$(cat configs/elastic.pass)"
addr="https://localhost:9200"

curl $auth $addr

curl $auth -X PUT "$addr/idx01"

curl $auth "$addr/_cat/indices?v"

curl $auth -X POST "$addr/idx/_doc/1" \
  -H 'Content-Type: application/json' \
  -d'{"title": "Test Document","content": "This is a test document."}'

curl $auth  "$addr/idx01/_search?q=content:test"

exit
####
auth=""
addr=http://localhost:9200

curl $auth $addr

curl $auth -X PUT "$addr/idx01"

curl $auth "$addr/_cat/indices?v"

curl $auth -X POST "$addr/idx/_doc/1" \
  -H 'Content-Type: application/json' \
  -d'{"title": "Test Document","content": "This is a test document."}'

curl $auth  "$addr/idx01/_search?q=content:test"

exit
