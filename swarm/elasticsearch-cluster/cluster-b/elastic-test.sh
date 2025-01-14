#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

# configs/elastic.yaml, configs/es.yaml
yaml=$1
ca=$(yq .ca $yaml)
password=$(yq .password $yaml)

port=${port:-9201}

if [[ "$ca" == "" || "$ca" == "null" ]]; then
    auth="-u elastic:$password"
    addr="http://localhost:$port"
else
    auth="--cacert $ca -u elastic:$password"
    addr="https://localhost:$port"
fi

####
echo -e "#### cluster"
curl $auth $addr -f
echo

echo -e "#### health"
curl $auth "$addr/_cluster/health" -f
echo

echo -e "#### nodes"
curl $auth $addr/_cat/nodes -f
echo

####
echo -e "#### add index: idx-test"
curl $auth -X PUT "$addr/idx-test"
echo

echo -e "#### indices"
curl $auth "$addr/_cat/indices?v" -f
echo

echo -e "#### add a document to idx-test"
curl $auth -X POST "$addr/idx-test/_doc/1" \
  -H 'Content-Type: application/json' \
  -d'{"title":"Test Document","content":"This is a test document."}' \
  -f
echo

echo -e "#### search documents from idx-test"
curl $auth "$addr/idx-test/_search?q=content:test" -f
echo
