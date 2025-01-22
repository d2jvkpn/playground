#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


####
config=${1:-/apps/configs/postgres_secondary.yaml}

data_dir=$(awk -v k="data_dir" '$0 ~ "^"k": " {print $2; exit}' $config)
subnet=$(awk -v k="subnet" '$0 ~ "^"k": " {print $2; exit}' $config)
role=$(awk -v k="role" '$0 ~ "^"k": " {print $2; exit}' $config)
replicator_user=$(awk -v k="replicator_user" '$0 ~ "^"k": " {print $2; exit}' $config)
replicator_password=$(awk -v k="replicator_password" '$0 ~ "^"k": " {print $2; exit}' $config)

primary_host=$(awk -v k="primary_host" '$0 ~ "^"k": " {print $2; exit}' $config)
primary_port=$(awk -v k="primary_port" '$0 ~ "^"k": " {print $2; exit}' $config)
delay_secs=$(awk -v k="delay_secs" '$0 ~ "^"k": " {print $2; exit}' $config)

####
if [ -f $data_dir/postgresql.conf ]; then
    echo "==> 4. Postgres(secondary) has been initialized, role=$role"
    postgres -D $data_dir
    exit
fi

####
echo "==> 1. Initializing: role=$role, primary_host=$primary_host, primary_port=$primary_port"
sleep $delay_secs

while ! nc -z $primary_host $primary_port; do
    sleep 1 && echo -n .
done

echo "==> 2. Sync data from the primary"
rm -rf $data_dir/* || true

echo $replicator_password |
  pg_basebackup -D $data_dir -Fp -Xs -R -c fast -P \
  --host=$primary_host --port=$primary_port --username=$replicator_user

cp $data_dir/postgresql.conf $data_dir/postgresql.conf.primary

conn="host=$primary_host port=$primary_port user=$replicator_user password=$replicator_password"

cat > $data_dir/postgresql.conf <<EOF


primary_conninfo = '$conn'
#synchronous_standby_names = 'standby01, standby02'
#primary_slot_name = 'your_replication_slot'
synchronous_commit = on
EOF
#application_name=NotWorking

echo "==> 3. Starting postgres secondary"
postgres -D $data_dir
# pg_ctl -D $data_dir start
