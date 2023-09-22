#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

#### mannual create containers
docker network create postgres-cluster

docker run -it --rm --user postgres -h postgres-node01 --name postgres-node01 \
  --net postgres-cluster postgres:15-alpine bash

docker run -it --rm --user postgres -h postgres-node02 --name postgres-node02 \
  --net postgres-cluster postgres:15-alpine bash

#### allow access from host machine
docker exec -it postgres-node01 bash
# trust means without password
# echo "host    all    all     172.25.0.0/16    trust" >> /var/lib/postgresql/data/pgdata/pg_hba.conf
# echo "host    all    all     172.25.0.0/16    scram-sha-256" >> /var/lib/postgresql/data/pgdata/pg_hba.conf

# yq .networks.net.ipam.config[0].subnet docker-compose.yaml

#### connect
psql --username=postgres --host=localhost --port=5441 --password

####
_sql="""
alter user postgres with encrypted password 'XXXXXXXX';

-- \password postgres

create role hello with encrypted password 'world';
alter role hello with login;
create database hello with owner = hello;

create table if not exists biz (
  id default gen_random_uuid() primary key,
  data text
);

insert into biz (data) values ('biz data1'), ('biz data2');

drop database hello;
drop role hello;
"""
