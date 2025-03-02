#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

port=${1:-9201}
addr=http://localhost:$port
auth="-u admin:abcABC123-@"

####
echo -e "######## cluster"
curl $addr -f
echo

echo -e "######## health"
curl "$addr/_cluster/health" -f
echo

echo -e "######## indices"
curl $auth "$addr/_cat/indices?v" -f
echo

echo -e "######## add a document"
curl $auth -X POST "$addr/idx-test/_doc/1" \
  -H 'Content-Type: application/json' \
  -d'{"title":"Test Document","content":"This is a test document."}' \
  -f
echo

echo -e "######## search"
curl $auth "$addr/idx-test/_search?q=content:test" -f
echo

echo -e "######## nodes"
curl $auth "$addr/_cat/nodes?v=true&format=yaml" -f
echo
