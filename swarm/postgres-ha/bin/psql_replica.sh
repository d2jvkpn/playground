#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

####
config=/app/configs/psql.yaml

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
    echo "==> nodes is ready: role=$role"
    postgres -D $data_dir
    exit
fi

####
echo "==> init psql node: role=$role, primary_host=$primary_host, primary_port=$primary_port"
sleep $delay_secs

while ! nc -z $primary_host $primary_port; do
    sleep 1 && echo -n .
done

echo "==> sync data from primary node"
rm -rf $data_dir/* || true

echo $replicator_password |
  pg_basebackup -D $data_dir -Fp -Xs -R -c fast -P \
  --host=$primary_host --port=$primary_port --username=$replicator_user

cp $data_dir/postgresql.conf $data_dir/postgresql.conf.primary

cat > $data_dir/postgresql.conf <<EOF
primary_conninfo = 'host=$primary_host port=$primary_port user=$replicator_user password=$replicator_password'
# synchronous_standby_names = 'standby_server_1, standby_server_2'
synchronous_commit = on
EOF
# application_name=NotWorking

postgres -D $data_dir
# pg_ctl -D $data_dir start
