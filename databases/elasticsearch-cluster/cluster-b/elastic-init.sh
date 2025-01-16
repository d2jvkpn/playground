#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


template=${_path}/elastic.template.yaml

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
  docker.elastic.co/elasticsearch/elasticsearch:8.17.0 \
  bash elastic-setup.sh

ls -alh configs/elastic.yaml configs/certs
