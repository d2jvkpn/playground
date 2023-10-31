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
docker exec -u postgres postgres-node02 ls -l /app/data

docker exec -u postgres postgres-node02 pg_ctl promote -D /app/data

docker exec -u postgres postgres-node02 psql -c "select pg_is_in_recovery();"
docker exec -u postgres postgres-node03 psql -c "select pg_is_in_recovery();"

docker exec -u postgres postgres-node02 bash -c '
  mv /app/data/postgresql.conf /app/data/postgresql.conf.replica && \
  cp /app/data/postgresql.conf.primary /app/data/postgresql.conf'

cp configs/postgres-node02.yaml configs/postgres-node02.yaml.bk
sed -i '/role: /s/replica/primary/' configs/postgres-node02.yaml

# docker restart postgres-node02
docker exec -u postgres postgres-node02 pg_ctl stop -D /app/data

docker exec -u postgres postgres-node02 ls -1l /app/data
docker logs postgres-node02

docker exec -u postgres postgres-node02 psql -x -c "select * from pg_stat_replication;"
docker exec -u postgres postgres-node02 psql -x -c "select * from pg_stat_wal_receiver;"

docker exec -u postgres postgres-node02 psql -U postgres \
  -c "insert into tests (data) values ('test data3'), ('test data4'); select * from tests;"

#### config node03
cp configs/postgres-node03.yaml configs/postgres-node03.yaml.bk
sed -i '/primary_host/s/postgres-node01/postgres-node02/' configs/postgres-node03.yaml

# docker exec -u postgres postgres-node03 bash -c "rm -rf /app/data/postgresql.conf"

docker exec -u postgres postgres-node03 bash -c \
  "sed -i 's/postgres-node01/postgres-node02/' /app/data/postgresql.conf /app/data/postgresql.auto.conf"

docker exec -u postgres postgres-node03 pg_ctl stop -D /app/data
# docker restart postgres-node02

#### check
docker exec -u postgres postgres-node02 psql -x -c "select * from pg_stat_replication;"
docker exec -u postgres postgres-node03 psql -x -c "select * from pg_stat_wal_receiver;"
docker exec -u postgres postgres-node03 psql -U postgres -c "select * from tests;"
