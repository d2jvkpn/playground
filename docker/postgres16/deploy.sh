#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

export APP_Tag=${1:-dev} PORT=${2:-5442}

mkdir -p configs/ data/postgres

envsubst < ${_path}/deploy.yaml > docker-compose.yaml

docker-compose pull
docker-compose up -d

exit

####
docker cp postgres16_${APP_Tag}:/var/lib/postgresql/data/pgdata/postgresql.conf configs/
docker cp postgres16_${APP_Tag}:/var/lib/postgresql/data/pgdata/pg_hba.conf configs/

docker exec -it postgres_db psql --username postgres --password postgres

psql --host 127.0.0.1 --port 5432 --username postgres --password postgres

```postgres
alter user postgres with password 'XXXXXXXX';

create user hello with password 'world';
create database db01 with owner = hello;
```

#### config
sed -i '/trust$/s/trust$/scram-sha-256/' pg_hba.conf

cat >> pg_hba.conf <<EOF
# Add settings for extensions here
host    all    postgres    127.0.0.1/32    trust
host    all    postgres    ::1/128         trust
EOF

#### set json log
docker exec postgres_db bash -c \
  "echo -e '\nlog_destination = jsonlog\nlogging_collector = on' >> /var/lib/postgresql/data/pgdata/postgresql.conf"

docker-compose down
docker-compose up

docker exec postgres_db ls /var/lib/postgresql/data/pgdata/log/
