#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


exit
# docker cp elastic01:/usr/share/elasticsearch/config/certs/http_ca.crt configs/
docker exec -it elastic01 \
  bash -c "printf 'y' | elasticsearch-reset-password -u elastic" |
  awk '/New value/{print $NF}' |
  dos2unix

exit
docker exec -it elastic01 \
  elasticsearch-create-enrollment-token -s kibana --url https://elastic01:9200 |
  dos2unix

docker exec -it elastic01 \
  elasticsearch-create-enrollment-token -s node --url https://elastic01:9200 |
  dos2unix

exit

# login with elastic
curl -s -X POST --cacert configs/elastic_config/certs/http_ca.crt \
  -u "elastic:$(cat configs/elastic.pass)" \
  -H "Content-Type: application/json" \
  https://localhost:9200/_security/user/kibana_system/_password -d '{"password":"foobar"}' 
