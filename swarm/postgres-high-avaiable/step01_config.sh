#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

nodes=(postgres-node{01..04})
subnet=$(yq .networks.net.ipam.config[0].subnet docker-compose.yaml)
replicator_user=replicator

mkdir -p configs data

#### primary
primary=${nodes[0]}
mkdir -p data/$primary
sudo chown 70:70 data/$primary
# sudo chmod 0750 data/$primary

password=$(tr -dc '0-9a-zA-Z._\-' < /dev/urandom | fold -w 32 | head -n 1 || true)

# data_dir: /var/lib/postgresql/data/pgdata
cat > configs/$primary.yaml << EOF
data_dir: /app/data
subnet: $subnet
role: primary
replicator_user: $replicator_user
replicator_password: $password
EOF

#### replica ${nodes[@]:1:3}
for node in ${nodes[@]:1}; do
    mkdir -p data/$node
    sudo chown 70:70 data/$node
    sudo chmod 0750 data/$node

cat > configs/$node.yaml << EOF
data_dir: /app/data
subnet: $subnet
role: replica
replicator_user: $replicator_user
replicator_password: $password

primary_host: $primary
primary_port: 5432
delay_secs: 5
EOF
done
