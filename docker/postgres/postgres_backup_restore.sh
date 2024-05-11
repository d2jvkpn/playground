#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

action=$1
container=$(yq .services.postgres.container_name docker-compose.yaml)

mkdir -p data

case "$action" in
"backup")
	database=$2
	output_file=data/$database.v$(date +%Y%m%d).sql

    # -F c -b
    # --format=c --large-objects -v -f /backup.sql
    docker exec $container pg_dump --host localhost --port 5432 --username postgres $database |
      pigz -c > $output_file.gz
    ;;
"restore")
	input_file=$2
	database=$(basename $input_file | sed 's/\.sql\.gz$//')

    # -v /usr/local/backup/10.70.0.61.backup
    docker cp $input_file $container:/temp_01.gz

    docker exec $container bash -c 'pigz -dc temp_01.gz | psql -h localhost -p 5432 -U postgres -f - '
    docker exec $container rm /temp_01.gz
    ;;
*)
    >&2 echo "==> nothing todo!"
    exit 1
;;
esac

exit
# https://www.postgresql.org/docs/current/continuous-archiving.html
tag=$(date +%Y%m%d%H%M%S%Z)

#### 1. backup a database
pg_dump --host=localhost --username=postgres --format=p \
  --file=backups/$db.sql $db

pg_restore --host=localhost --username=postgres --clean --verbose --version \
  --dbname=$db --file=backups/$db.sql

#### 2. full backup
pg_basebackup --host=localhost --username=postgres \
  --format=t --wal-method=stream --progress \
  --pgdata=backup_$(date +%Y%m%d%H%M%S)
# ls -1 backup_$(date +%F) # backup_manifest base.tar pg_wal.tar

#### 3. wal
# conf=$(cat postgresql.conf)
# /var/lib/postgresql/data/pgdata/postgresql.conf
# docker exec postgres bash -c "echo \"$conf\" >> pgdata/postgresql.conf"

docker cp postgresql.conf postgres:/pgdata/postgresql.custom.conf

start_stats="SELECT pg_backup_start(label => 'label', fast => false)"
stop_stats="SELECT * FROM pg_backup_stop(wait_for_archive => true)"

docker exec -u postgres postgres psql -c "select pg_reload_conf(); $start_stats; $stop_stats"

docker exec postgres ls -al pgdata/pg_wal wal_archive

#### 4. retore
touch pgdata/recovery.signal
