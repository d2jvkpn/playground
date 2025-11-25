#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

addr="https://localhost:9200"
auth="-k -u admin:abcABC123@_"

####
echo "######## cluster"
curl $auth $addr -f
echo

echo "######## health"
curl $auth "$addr/_cluster/health" -f
echo

echo "######## nodes"
curl $auth "$addr/_cat/nodes?v=true&format=yaml" -f |
  tee configs/nodes.yaml
echo

echo "######## indices"
curl $auth "$addr/_cat/indices?v" -f
echo

####
echo "######## add a document"
curl $auth -X POST "$addr/idx-test/_doc/1" \
  -H 'Content-Type: application/json' \
  -d'{"title":"Test Document","content":"This is a test document."}' \
  -f
echo

echo "######## search"
curl $auth "$addr/idx-test/_search?q=content:test" -f
echo
