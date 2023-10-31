#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

#### stop primary container postgres-node01
docker stop postgres-node01

docker exec -u postgres postgres-node02 psql -x -c "select * from pg_stat_wal_receiver;"
docker exec -u postgres postgres-node03 psql -x -c "select * from pg_stat_wal_receiver;"

docker exec -u postgres postgres-node02 psql -U postgres -c "select * from tests;"

#### switch postgres-node02 as primary node
docker exec -u postgres postgres-node02 ls -l /var/lib/postgresql/data/pgdata

docker exec -u postgres postgres-node02 pg_ctl promote -D /var/lib/postgresql/data/pgdata

docker exec -u postgres postgres-node02 psql -c "select pg_is_in_recovery();"
docker exec -u postgres postgres-node03 psql -c "select pg_is_in_recovery();"

docker exec -u postgres postgres-node02 bash -c '
  cd /var/lib/postgresql/data/pgdata &&
  mv postgresql.conf postgresql.conf.replica && \
  cp postgresql.conf.primary postgresql.conf'

sed -i '/node_kind/s/replica/primary/' configs/node02.env

# docker restart postgres-node02
docker exec -u postgres postgres-node02 pg_ctl stop -D /var/lib/postgresql/data/pgdata

docker exec -u postgres postgres-node02 ls -1l /var/lib/postgresql/data/pgdata
docker logs postgres-node02

docker exec -u postgres postgres-node02 psql -x -c "select * from pg_stat_replication;"
docker exec -u postgres postgres-node02 psql -x -c "select * from pg_stat_wal_receiver;"

docker exec -u postgres postgres-node02 psql -U postgres \
  -c "insert into tests (data) values ('test data3'), ('test data4'); select * from tests;"

#### config node03
sed -i '/primary_host/s/postgres-node01/postgres-node02/' configs/node03.env
# docker exec -u postgres postgres-node03 bash -c "rm -rf /var/lib/postgresql/data/pgdata/postgresql.conf"

docker exec -u postgres postgres-node03 bash -c \
  "cd /var/lib/postgresql/data/pgdata/ && \
  sed -i 's/postgres-node01/postgres-node02/' postgresql.conf postgresql.auto.conf"

docker exec -u postgres postgres-node03 pg_ctl stop -D /var/lib/postgresql/data/pgdata
# docker restart postgres-node02

#### check
docker exec -u postgres postgres-node02 psql -x -c "select * from pg_stat_replication;"
docker exec -u postgres postgres-node03 psql -x -c "select * from pg_stat_wal_receiver;"
docker exec -u postgres postgres-node03 psql -U postgres -c "select * from tests;"
