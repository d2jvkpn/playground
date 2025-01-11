#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


####
mkdir -p configs data/es{01..03} logs/es{01..03}

# sysctl -w vm.max_map_count=262144
[ ! -s configs/sysctl.conf ] &&
{
    docker run --rm docker.elastic.co/elasticsearch/elasticsearch:8.17.0 cat /etc/sysctl.conf
    echo "vm.max_map_count=262144"
} > configs/sysctl.conf

awk 'BEIGIN{k=0} /^####/{k=1} k==0{print}' compose.template.yaml > compose.yaml

docker-compose up -d

until nc -zv localhost 9200; do
    echo "--> waiting"
    sleep 3
done

####
docker exec -it es01 \
  bash -c "printf 'y' | elasticsearch-reset-password -u elastic" |
  awk '/New value/{print $NF}' |
  dos2unix > configs/elastic.pass

echo "==> saved configs/elastic.pass"

docker exec -it es01 \
  elasticsearch-create-enrollment-token -s kibana |
  dos2unix > configs/kibana.pass
echo "==> saved configs/kibana.pass"

docker exec -it es01 \
  elasticsearch-create-enrollment-token -s node |
  dos2unix > configs/node.pass
echo "==> saved configs/node.pass"

docker cp es01:/usr/share/elasticsearch/config/certs/http_ca.crt configs/

####
export ENROLLMENT_TOKEN=$(cat configs/node.pass)

{
    echo ""
    awk 'BEIGIN{k=0} /^####/{k=1} k==1{print}' compose.template.yaml | envsubst
} >> compose.yaml

docker-compose up -d
