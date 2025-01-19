#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


#### 1. 
[ ! -s compose.yaml ] && cp compose.template.yaml compose.yaml

nodes=(postgres-node{01..04})
subnet=$(yq .networks.net.ipam.config[0].subnet compose.yaml)
replicator_user=replicator
image=$(grep "image: " compose.yaml | awk 'NR==1{print $2; exit}')

mkdir -p configs data
primary=${nodes[0]}

mkdir -p data/$primary

docker run -u root --rm -it -v $PWD/data:/apps/data $image \
  bash -c "chown 70:70 /apps/data/$primary"

for node in ${nodes[@]:1}; do
    mkdir -p data/$node

    docker run -u root --rm -it -v $PWD/data:/apps/data $image \
      bash -c "chown 70:70 /apps/data/$node && chmod 0750 /apps/data/$node"
done

#### 2. 
if [ ! -s configs/postgres.pass ]; then
    password=$(tr -dc '0-9a-zA-Z' < /dev/urandom | fold -w 32 | head -n 1 || true)
    echo "$password" > configs/postgres.pass
fi

replicator_password=$(tr -dc '0-9a-zA-Z' < /dev/urandom | fold -w 32 | head -n 1 || true)

# data_dir: /var/lib/postgresql/data/pgdata
[ -s configs/postgres_primary.yaml ] || cat > configs/postgres_primary.yaml <<EOF
data_dir: /apps/data
subnet: $subnet
role: primary
replicator_user: $replicator_user
replicator_password: $replicator_password
EOF

[ -s configs/postgres_replicator.yaml ] || cat > configs/postgres_replicator.yaml <<EOF
data_dir: /apps/data
subnet: $subnet
role: replica
replicator_user: $replicator_user
replicator_password: $replicator_password

primary_host: $primary
primary_port: 5432
delay_secs: 5
EOF
