#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


docker exec -it elastic-node01 \
  elasticsearch-reset-password -u elastic --url https://localhost:9200 |
  awk '/New value/{print $NF}' |
  dos2unix

docker exec -it elastic-node01 \
  elasticsearch-reset-password -u kibana_system --batch |
  awk '/New value/{print $NF}' |
  dos2unix

docker exec kibana cat data/verification_code | dos2unix

####
docker exec -it elastic-node01 \
  elasticsearch-create-enrollment-token -s kibana --url https://localhost:9200 |
  dos2unix

docker exec -it es-node01 \
  elasticsearch-create-enrollment-token -s node --url https://localhost:9200 |
  dos2unix

####
curl -s -X POST --cacert configs/certs/ca.crt \
  -u "elastic:$(cat configs/certs/elastic.pass)" \
  -H "Content-Type: application/json" \
  https://localhost:9200/_security/user/kibana_system/_password -d '{"password":"foobar"}'
