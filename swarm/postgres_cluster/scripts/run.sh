#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

node=$1
env_file=/data/configs/${node}.env
. $env_file

echo "$data_dir, $node_kind" > /dev/null

if [ -f $data_dir/postgresql.conf ]; then
    echo "==> postgres up, node: $node, kind: $node_kind"
    postgres -D $data_dir
    exit
fi

if [ "$node_kind" == "primary" ]; then
    bash ${_path}/config_primary.sh $node $env_file
elif [ "$node_kind" == "replica" ]; then
    bash ${_path}/config_replica.sh $node $env_file
else
    &>2 echo '!!! Unkonwn kind: '"$node_kind"''
    exit 1
fi

echo "==> postgres start, node: $node, kind: $node_kind"
postgres -D $data_dir
