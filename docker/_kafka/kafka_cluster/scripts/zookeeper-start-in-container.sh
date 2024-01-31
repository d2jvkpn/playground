#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

zookeeper_id=$(printenv KAFKA_ZookeeperId)
[ -z "$zookeeper_id" ] && { >&2 echo "KAFKA_ZookeeperId is unset"; exit 1; }

echo -e ">>> zookeeper_id: $zookeeper_id\n"
[ -f /data/zookeeper/myid ] || echo "$zookeeper_id" > /data/zookeeper/myid

# -daemon
bin/zookeeper-server-start.sh zookeeper.properties
