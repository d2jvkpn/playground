#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


config=${1:-/apps/configs/postgres_primary.yaml}

data_dir=$(awk -v k="data_dir" '$0 ~ "^"k": " {print $2; exit}' $config)
subnet=$(awk -v k="subnet" '$0 ~ "^"k": " {print $2; exit}' $config)
role=$(awk -v k="role" '$0 ~ "^"k": " {print $2; exit}' $config)
replicator_user=$(awk -v k="replicator_user" '$0 ~ "^"k": " {print $2; exit}' $config)
replicator_password=$(awk -v k="replicator_password" '$0 ~ "^"k": " {print $2; exit}' $config)

####
if [ -s $data_dir/postgresql.conf ]; then
    echo "==> 6. Postgres(primary) has been initialized: role=$role"
    postgres -D $data_dir
    exit
fi

####
echo "==> 1. Initializing postgres: role=$role"

# initdb -D $data_dir
# psql -U postgres -c 'SHOW config_file'
pg_ctl init -D $data_dir

####
echo "==> 2. Starting postgres"
pg_ctl -D $data_dir start

psql --username postgres \
  -c "CREATE USER $replicator_user REPLICATION LOGIN ENCRYPTED PASSWORD '$replicator_password'";
# select rolpassword from pg_authid where rolname = 'replicator';

####
echo "==> 3. Update config of postgres"
cat >> $data_dir/postgresql.conf <<EOF


log_filename = 'postgresql-%Y-%m'
log_destination = jsonlog
logging_collector = on
log_hostname = on # pg_stat_replication.client_hostname

#archive_mode = on
#archive_command = 'cp %p /path/to/archive/%f'

listen_addresses = '*'
wal_level = replica
max_wal_senders = 8
wal_keep_size = 256
wal_sender_timeout = 60
hot_standby = on

#synchronous_standby_names = '"standby01", "standby02", "standby03"'
#synchronous_standby_names = 'FIRST 1 ("standby01", "standby02", "standby03")'
#synchronous_standby_names = 'ANY 1 ("standby01", "standby02", "standby03")'
synchronous_standby_names = 'ANY 1 ("*")'
EOF

# sed -i '/trust$/s/trust$/scram-sha-256/' pg_hba.conf
cat >> $data_dir/pg_hba.conf <<EOF


# Add settings for extensions here
# host    all            postgres      127.0.0.1/32    trust
# host    all            postgres      ::1/128         trust
host    replication    replicator    $subnet    scram-sha-256
host    all            all           $subnet    scram-sha-256
EOF
# host    replication    replicator    0.0.0.0/0    trust

echo "==> 4. Stopping postgres"
pg_ctl -D $data_dir stop -m fast

echo "==> 5. Starting postgres primary"
# pg_ctl -D $data_dir start
# pg_ctl -D $data_dir restart
postgres -D $data_dir
