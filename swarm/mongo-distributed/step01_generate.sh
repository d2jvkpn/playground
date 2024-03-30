#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

#### generate directories, ssl cert

mkdir -p data/configsvr-1{a..c}/{db,logs}
mkdir -p data/mongos-{1..3}/{db,logs}
mkdir -p data/shard-{1..3}{a..c}/{db,logs}

if [ ! -s configs/mongo_cluster.key ]; then
    openssl rand -base64 756 > configs/mongo_cluster.key
    chmod 600 configs/mongo_cluster.key
fi

if [ ! -s configs/mongo.secret ]; then
    tr -dc '0-9a-zA-Z' < /dev/urandom | fold -w 32 |
      head -n 1 > configs/mongo.secret || true
fi

#### configsvr
ls configs/{configsvr.conf,mongos.conf,shard.conf}\
  bin/{configsvr.js,create-root.js,mongos.js,shard.js} &> /dev/null

configsvr_id=configsvr-1

repl_set_name=$configsvr_id envsubst < configs/configsvr.conf |
  sed '/^#/d' > configs/configsvr-1.conf

#### shard
for shard in shard-{1,2,3}; do
    repl_set_name=$shard envsubst < configs/shard.conf |
      sed '/^#/d' > configs/$shard.conf
done

config_db=$configsvr_id/mongo-configsvr-1a:27017,mongo-configsvr-1b:27017,mongo-configsvr-1c:27017

for idx in {1..3}; do
    node=mongos-${idx}
    # ip=$(yq .services.$node.networks[].ipv4_address docker_deploy.yaml)

    config_db=$config_db bind_ip=mongo-$node \
      envsubst < configs/mongos.conf | sed '/^#/d' > configs/$node.conf
done
