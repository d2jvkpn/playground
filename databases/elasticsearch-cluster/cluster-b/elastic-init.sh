#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


#### 1. check vm.max_map_count
vm_max_map_count=$(sysctl -a 2> /dev/null | awk -F ' *= *' '$1=="vm.max_map_count"{print $2}')

if [ "$vm_max_map_count" -lt 262144 ]; then
    echo "vm.max_map_count is too low,  increase to at least [262144]"
    echo "run sysctl -w vm.max_map_count=262144 or add to /etc/sysctl.conf"
    exit 1
fi

template=${_path}/elastic.template.yaml


#### 2. generate certs
mkdir -p configs/certs

[ ! -s configs/elastic.yaml ] && {
    password=$(tr -dc '0-9a-zA-Z' < /dev/urandom | fold -w 32 | head -n1 || true)
    PASSWORD="$password" envsubst < $template > configs/elastic.yaml
}

yq .password configs/elastic.yaml > configs/certs/elastic.pass
yq e '{"instances": .instances}' configs/elastic.yaml > configs/certs/instances.yaml

cat configs/certs/instances.yaml

for name in $(yq .instances[].name configs/elastic.yaml); do
    if [ -s configs/$name/elasticsearch.yml ]; then
        echo '!!! file already exists:' configs/$name/elasticsearch.yml
        exit 1
    fi

    mkdir -p data/$name
done

docker run --rm -u root:root -w /usr/share/elasticsearch \
  -v ${PWD}/elastic-setup.sh:/usr/share/elasticsearch/elastic-setup.sh \
  -v ${PWD}/configs/certs:/usr/share/elasticsearch/config/certs \
  docker.elastic.co/elasticsearch/elasticsearch:8.17.2 \
  bash elastic-setup.sh

ls -alh configs/elastic.yaml configs/certs


#### 3. copy configs of kibana
mkdir -p configs/es-kibana data/es-kibana

docker run --rm -u root:root -w /usr/share/kibana \
  -v ${PWD}/configs/es-kibana:/tmp/es-kibana \
  docker.elastic.co/kibana/kibana:8.17.2 \
  bash -c 'cp config/* /tmp/es-kibana && chown -R kibana:root /tmp/es-kibana'
