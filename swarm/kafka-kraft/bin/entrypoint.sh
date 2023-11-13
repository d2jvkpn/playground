#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

cluster_id=$(awk '/^cluster_id: /{print $2; exit}' ./kafka.yaml)

[ -z "$cluster_id" ] && { >&2 echo "cluster_id is unset in ./kafka.yaml"; exit 1; }

kafka-storage.sh format --ignore-formatted -t $cluster_id -c ./server.properties

kafka-server-start.sh server.properties
# kafka-server-start.sh -daemon configs/server.properties
