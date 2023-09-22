#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

# https://utho.com/docs/tutorial/how-to-install-postgresql-15-on-ubuntu-22-04/

#### step1 install
sudo echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" \
  > /etc/apt/sources.list.d/pgdg.list

wget -qO- https://www.postgresql.org/media/keys/ACCC4CF8.asc |
  sudo tee /etc/apt/trusted.gpg.d/pgdg.asc &>/dev/null

sudo apt update
apt-cache search psql
sudo apt install postgresql postgresql-client -y

#### step2 change password
sudo systemctl status postgresql
# sudo systemctl disable postgresql

psql --version

# sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'YOUR_Password';"

psql -h localhost -U postgres
# interactive shell
_sql="""
ALTER USER postgres PASSWORD 'YOUR_Password';
CREATE USER replicator REPLICATION LOGIN ENCRYPTED PASSWORD 'REPLICATOR_Password';
"""

sudo su - postgres
export PATH=/usr/lib/postgresql/15/bin/initdb:$PATH
data_dir=/etc/postgresql/15/main

#### step3 config postgresql.conf
grep listen_address /etc/postgresql/15/main/postgresql.conf

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

ls -1 /etc/postgresql/15/main/

#### step2 config pg_hba.conf
cat $data_dir/pg_hba.conf

replicator_addr=192.168.0.0/24

cat >> $data_dir/pg_hba.conf <<EOF
# Add settings for extensions here
host    replication    replicator    $replicator_addr    scram-sha-256
EOF

systemctl restart postgresql

#### step3 config slave nodes
systemctl stop postgresql

sudo su - postgres
export PATH=/usr/lib/postgresql/15/bin/initdb:$PATH
data_dir=/var/lib/postgresql/15/main
rm -r $data_dir

MASTER_Host=192.168.x.y
REPLICATOR_Password='xxxxxxxx'
slave=slave1

pg_basebackup -D $data_dir -Fp -Xs -R -c fast -P -h $MASTER_Host -U replicator

cat > $data_dir/postgresql.conf <<EOF
primary_conninfo = 'host=$MASTER_Host port=$MASTER_Port user=replicator password=$REPLICATOR_Password'
synchronous_standby_names = '$slave'
EOF

postgres -D $data_dir

systemctl restart postgresql
