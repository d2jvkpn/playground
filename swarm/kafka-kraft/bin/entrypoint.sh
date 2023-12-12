#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

# PWD: /app
yaml_config=./kafka/kafka.yaml
config=./kafka/kafka.properties

cluster_id=$(awk '/^cluster_id: /{print $2; exit}' $yaml_config)

[ -z "$cluster_id" ] && { >&2 echo "cluster_id is unset in $yaml_config"; exit 1; }
[ ! -f "$config" ] && ${_path}/kraft_config.sh $yaml_config $config

mkdir -p kafka/{data,logs}

kafka-storage.sh format --ignore-formatted -t $cluster_id -c $config # --add-scram

kafka-server-start.sh $config "$@"
# kafka-server-start.sh -daemon $config
