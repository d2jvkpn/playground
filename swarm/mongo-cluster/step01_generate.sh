#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


#### 1. generate directories, ssl cert
mkdir -p configs docs

mkdir -p data/configsvr-1{a..c}/{db,logs}
mkdir -p data/shard-{1..3}{a..c}/{db,logs}
mkdir -p data/mongos-{1..3}/{db,logs}

[ -s docs/configsvr.conf ] || cat > docs/configsvr.conf <<'EOF'
storage:
  dbPath: /data/db
  journal:
    commitIntervalMs: 500
systemLog:
  destination: file
  logAppend: true
  path: /var/log/mongodb/mongod.log
net:
  port: 27017
  # bindIp: 127.0.0.1
replication:
  replSetName: ${repl_set_name}
sharding:
  clusterRole: configsvr
security:
  authorization: enabled
  keyFile: /apps/configs/mongo.key
EOF

[ -s docs/mongos.conf ] || cat > docs/mongos.conf <<'EOF'
net:
  port: 27017
  bindIp: localhost,127.0.0.1,${bind_ip}
sharding:
  configDB: ${config_db}
security:
  keyFile: /apps/configs/mongo.key
EOF

[ -s docs/shard.conf ] || cat > docs/shard.conf <<'EOF'
storage:
  dbPath: /data/db
  journal:
    commitIntervalMs: 500
systemLog:
  destination: file
  logAppend: true
  path: /var/log/mongodb/mongod.log
net:
  port: 27017
  # bindIp: 127.0.0.1
replication:
  replSetName: ${shard}
sharding:
  clusterRole: shardsvr
security:
  authorization: enabled
  keyFile: /apps/configs/mongo.key
EOF

#### 2. generate key and secret
if [ ! -s configs/mongo.key ]; then
    openssl rand -base64 756 > configs/mongo.key
    chmod 600 configs/mongo.key
fi

if [ ! -s configs/mongo.secret ]; then
    tr -dc '0-9a-zA-Z' < /dev/urandom | fold -w 32 | head -n 1 > configs/mongo.secret || true
fi

#### 3. configsvr
ls docs/{configsvr.conf,mongos.conf,shard.conf} \
  bin/{configsvr.js,create-root.js,mongos.js,shard.js}

configsvr_id=configsvr-1

repl_set_name=$configsvr_id envsubst < docs/configsvr.conf |
  sed '/^#/d' > configs/configsvr-1.conf

#### 4. shard
for shard in shard-{1,2,3}; do
    shard=$shard envsubst < docs/shard.conf | sed '/^#/d' > configs/$shard.conf
done

config_db=$configsvr_id/mongo-configsvr-1a:27017,mongo-configsvr-1b:27017,mongo-configsvr-1c:27017

#### 5. mongos.conf
for idx in {1..3}; do
    node=mongos-${idx}
    # ip=$(yq .services.$node.networks[].ipv4_address docker_deploy.yaml)

    config_db=$config_db bind_ip=mongo-$node \
      envsubst < docs/mongos.conf | sed '/^#/d' > configs/$node.conf
done

cat > configs/mongo.config.json <<EOF
{
  "configsvr": {
    "id": "configsvr-1",
    "members": [
      {"_id": 1, "host": "mongo-configsvr-1a:27017"},
      {"_id": 2, "host": "mongo-configsvr-1b:27017"},
      {"_id": 3, "host": "mongo-configsvr-1c:27017"}
    ]
  },
  "shards": [
    {
      "name": "shard-1",
      "hosts": ["mongo-shard-1a:27017", "mongo-shard-1b:27017", "mongo-shard-1c:27017"]
    },
    {
      "name": "shard-2",
      "hosts": ["mongo-shard-2a:27017", "mongo-shard-2b:27017", "mongo-shard-2c:27017"]
    },
    {
      "name": "shard-3",
      "hosts": ["mongo-shard-3a:27017", "mongo-shard-3b:27017", "mongo-shard-3c:27017"]
    }
  ]
}
EOF
