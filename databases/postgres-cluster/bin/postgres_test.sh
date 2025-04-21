#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


# select client_addr, client_hostname, state, sync_priority, sync_state from pg_stat_replication;
docker exec -u postgres postgres-node01 psql -x -c "select * from pg_stat_replication;"

docker exec -u postgres postgres-node02 psql -x -c "select * from pg_stat_wal_receiver;"
docker exec -u postgres postgres-node03 psql -x -c "select * from pg_stat_wal_receiver;"

docker exec -u postgres postgres-node01 psql -U postgres \
  -c "create table if not exists tests (id serial primary key, data text); \
  insert into tests (data) values ('test data1'), ('test data2');"

# docker exec -u postgres -it postgres-node01 psql
docker exec -u postgres postgres-node01 psql -U postgres -c "select * from tests;"

docker exec -u postgres postgres-node02 psql -U postgres -c "select * from tests;"
docker exec -u postgres postgres-node03 psql -U postgres -c "select * from tests;"

# psql --user postgres --host 127.0.0.1 --port 5441 -c "select * from tests;"

####
docker exec -u postgres postgres-node01 psql -U postgres \
  -c "create role hello with encrypted password 'world';" \
  -c "alter role hello with login;" \
  -c "create database hello with owner = hello;"

docker exec postgres-node01 psql -U hello \
  -c "create table if not exists biz (id uuid default gen_random_uuid() primary key, data text);
  insert into biz (data) values ('biz data1'), ('biz data2');"

docker exec postgres-node01 psql --user hello --host 127.0.0.1 --port 5432 -c "select * from biz;"

docker exec postgres-node02 psql --user hello --host 127.0.0.1 --port 5432 -c "select * from biz;"
docker exec postgres-node03 psql --user hello --host 127.0.0.1 --port 5432 -c "select * from biz;"

docker exec -u postgres postgres-node01 psql -U postgres \
  -c "drop database hello;" \
  -c "drop role hello;"
