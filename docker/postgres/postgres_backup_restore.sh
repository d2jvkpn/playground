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

    # -F c -b -v -f /backup.sql
    docker exec $container pg_dump -h localhost -p 5432 -U postgres $database |
      pigz -c > $output_file.gz
    ;;
"restore")
	input_file=$2
	database=$(basename $input_file | sed 's/\.sql\.gz$//')

    # -v /usr/local/backup/10.70.0.61.backup
    docker cp $input_file $container:/temp_01.gz

    docker exec $container bash -c 'gzip -dc temp_01.gz | psql -h localhost -p 5432 -U postgres -f - '
    docker exec $container rm /temp_01.gz
    ;;
*)
    >&2 echo "==> nothing todo!"
    exit 1
;;
esac
