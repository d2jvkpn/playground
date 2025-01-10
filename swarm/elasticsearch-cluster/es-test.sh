#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

ca=$(yq .ca configs/elastic.yaml)
password=$(yq .password configs/elastic.yaml)

auth="--cacert $ca -u elastic:$password"
addr="https://localhost:9200"

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
