#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


#### 1. check vm.max_map_count
vm_max_map_count=$(sysctl -a 2> /dev/null | awk -F ' *= *' '$1=="vm.max_map_count"{print $2}')

if [ "$vm_max_map_count" -lt 262144 ]; then
    echo "vm.max_map_count is too low,  increase to at least [262144]"
    echo "run sysctl -w vm.max_map_count=262144 or add to /etc/sysctl.conf"
    exit 1
fi

if [ ! -s compose.yaml ]; then
    cp compose.elastic.yaml compose.yaml
    echo "==> Created compose from compose.elastic.yaml: compose.yaml"
else
    echo "==> Using existing compose file: compose.yaml"
fi
version=$(yq .services.kibana.image compose.yaml | awk -F ":" '{print $2}')

#### 2. generate certs
mkdir -p configs/certs

if [ ! -s configs/elastic.yaml ]; then
    password=$(tr -dc '0-9a-zA-Z' < /dev/urandom | fold -w 32 | head -n1 || true)
    PASSWORD="$password" envsubst < elastic.config.yaml > configs/elastic.yaml
    echo "==> Created config file: configs/elastic.yaml"
else
    echo "==> Using existing config file: configs/elastic.yaml"
fi

yq .password configs/elastic.yaml > configs/certs/elastic.pass
yq e '{"instances": .instances}' configs/elastic.yaml > configs/certs/instances.yaml

cat configs/certs/instances.yaml

for name in $(yq .instances[].name configs/elastic.yaml); do
    if [ -s configs/$name/elasticsearch.yml ]; then
        echo '!!! File already exists:' configs/$name/elasticsearch.yml
        exit 1
    fi

    mkdir -p data/$name/data data/$name/plugins
done

docker run --rm -u root:root -w /usr/share/elasticsearch \
  -v ${PWD}/elastic-certs.sh:/opt/elastic-certs.sh \
  -v ${PWD}/configs/certs:/usr/share/elasticsearch/config/certs \
  docker.elastic.co/elasticsearch/elasticsearch:$version \
  bash /opt/elastic-certs.sh config/certs/instances.yaml

ls -alh configs/elastic.yaml configs/certs


#### 3. copy configs of kibana
mkdir -p configs/elastic-kibana data/elastic-kibana

docker run --rm -u root:root -w /usr/share/kibana \
  -v ${PWD}/configs/elastic-kibana:/tmp/elastic-kibana \
  docker.elastic.co/kibana/kibana:$version \
  bash -c 'cp config/* /tmp/elastic-kibana && chown -R kibana:root /tmp/elastic-kibana'
