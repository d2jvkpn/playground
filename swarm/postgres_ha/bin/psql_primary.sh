#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

config=/app/configs/psql.yaml

data_dir=$(awk -v k="data_dir" '$0 ~ "^"k": " {print $2; exit}' $config)
subnet=$(awk -v k="subnet" '$0 ~ "^"k": " {print $2; exit}' $config)
role=$(awk -v k="role" '$0 ~ "^"k": " {print $2; exit}' $config)
replicator_user=$(awk -v k="replicator_user" '$0 ~ "^"k": " {print $2; exit}' $config)
replicator_password=$(awk -v k="replicator_password" '$0 ~ "^"k": " {print $2; exit}' $config)

####
if [ -f $data_dir/postgresql.conf ]; then
    echo "==> nodes is ready: role=$role"
    postgres -D $data_dir
    exit
fi

####
echo "==> init psql node: role=$role"

# initdb -D $data_dir
# psql -U postgres -c 'SHOW config_file'
pg_ctl init -D $data_dir

cat >> $data_dir/postgresql.conf <<EOF
log_filename = 'postgresql-%Y-%m'
log_destination = jsonlog
logging_collector = on

listen_addresses = '*'
wal_level = replica
max_wal_senders = 10
wal_keep_size = 256
hot_standby = on
EOF

# sed -i '/trust$/s/trust$/scram-sha-256/' pg_hba.conf
cat >> $data_dir/pg_hba.conf <<EOF
# Add settings for extensions here
# host    all            postgres      127.0.0.1/32    trust
# host    all            postgres      ::1/128         trust
host    replication    replicator    $subnet         scram-sha-256
host    all            all           $subnet         scram-sha-256
EOF
# host    replication    replicator    0.0.0.0/0    trust

####
pg_ctl -D $data_dir start

psql --username postgres \
  -c "CREATE USER $replicator_user REPLICATION LOGIN ENCRYPTED PASSWORD '$replicator_password'";
# select rolpassword from pg_authid where rolname = 'replicator';

pg_ctl -D $data_dir stop
# pg_ctl -D $data_dir start
# pg_ctl -D $data_dir restart
postgres -D $data_dir
