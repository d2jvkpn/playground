#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit
mkdir -p configs

[ -s configs/postgres.pass ] || \
  tr -dc 'a-zA-Z0-9' < /dev/urandom | fold -w 32 | head -n1 > configs/postgres.pass || true

docker exec postgres psql postgres://postgres@localhost:5432/postgres \
  -c "ALTER ROLE postgres WITH PASSWORD '$(cat configs/postgres.pass)'"

exit
psql postgres://username:password@localhost:5432/postgres

createuser --username=postgres hello --createdb --login

cat <<EOF
create user hello with login password 'world';

ALTER ROLE hello CREATEDB;
ALTER ROLE hello LOGIN;
ALTER ROLE hello SUPERUSER;

\password hello

create database hello owner=hello;
EOF

exit
select uuidv7();

select * from pg_available_extensions;

create extension if not exists pg_stat_statements;

select query, calls, total_exec_time
from pg_stat_statements
order by total_exec_time desc
limit 10;

CREATE EXTENSION IF NOT EXISTS vector;

create extension postgis;
select ST_Distance(
  ST_Point(0,0),
  ST_Point(1,1)
);
