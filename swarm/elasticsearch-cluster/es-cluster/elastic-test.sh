#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

# configs/elastic.yaml, configs/es.yaml
yaml=$1
ca=$(yq .ca $yaml)
password=$(yq .password $yaml)

if [[ "$ca" == "" || "$ca" == "null" ]]; then
    auth="-u elastic:$password"
    addr="http://localhost:9200"
else
    auth="--cacert $ca -u elastic:$password"
    addr="https://localhost:9200"
fi

echo -e "\n\n######## cluster"
curl $auth $addr -f

echo -e "\n\n######## health"
curl $auth "$addr/_cluster/health" -f

echo -e "\n\n######## add index idx-test"
curl $auth -X PUT "$addr/idx-test"

echo -e "\n\n######## indices"
curl $auth "$addr/_cat/indices?v" -f

echo -e "\n\n######## add document"
curl $auth -X POST "$addr/idx-test/_doc/1" \
  -H 'Content-Type: application/json' \
  -d'{"title":"Test Document","content":"This is a test document."}' \
  -f

echo -e "\n\n######## search"
curl $auth "$addr/idx-test/_search?q=content:test" -f

echo -e "\n\n######## nodes"
curl $auth $addr/_cat/nodes -f

exit

docker exec -it es01 bash -c \
  "printf 'y' | elasticsearch-reset-password -u elastic --url https://localhost:9200" |
  awk '/New value/{print $NF}' |
  dos2unix

#### TODO
docker exec -it es01 bash -c \
  "elasticsearch-create-enrollment-token -s kibana --url https://localhost:9200" |
  dos2unix

docker exec -it es01 bash -c \
  "elasticsearch-create-enrollment-token -s node --url https://localhost:9200" |
  dos2unix
