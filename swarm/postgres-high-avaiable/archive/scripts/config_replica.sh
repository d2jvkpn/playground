#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

####
node=$1
env_file=$2
. $env_file
replicator_password=$(awk '{print $1; exit}' /data/configs/secret_replicator.txt)

echo "$data_dir, $node_kind, $replicator_password" > /dev/null
echo "==> config_replica, primary_host: $primary_host, primary_port: $primary_port"
sleep $delay_secs

while ! nc -z $primary_host $primary_port; do
    sleep 1 && echo -n .
done

echo "==> sync data from primary node"
rm -rf $data_dir/* || true

echo $replicator_password |
  pg_basebackup -D $data_dir -Fp -Xs -R -c fast -P \
  --host=$primary_host --port=$primary_port --username=replicator

cp $data_dir/postgresql.conf $data_dir/postgresql.conf.primary

# primary_conninfo = 'host=primary_host port=5432 user=replicator password=my_password dbname=my_database sslmode=require sslcert=/path/to/client.crt sslkey=/path/to/client.key'

cat > $data_dir/postgresql.conf <<EOF
primary_conninfo = 'host=$primary_host port=$primary_port user=replicator password=$replicator_password'
# synchronous_standby_names = 'standby_server_1, standby_server_2'
synchronous_commit = on
EOF
# application_name=NotWorking

# pg_ctl -D $data_dir start
