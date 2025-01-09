#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

# PWD: /apps
yaml=./data/kafka/kafka.yaml
conf=./data/kafka/kafka.properties

#cluster_id=$(awk '/^cluster_id: /{print $2; exit}' $yaml)
cluster_id=$(yq .cluster_id $yaml)

[ -z "$cluster_id" ] && { >&2 echo "cluster_id is unset in $yaml"; exit 1; }
${_path}/kafka-kraft_config.sh $yaml $conf

kafka-storage.sh format --ignore-formatted -t $cluster_id -c $conf # --add-scram

# -daemon
kafka-server-start.sh $conf $@