#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

action=$1

container=$(yq .services.mysql.container_name docker-compose.yaml)

case "$action" in
"backup")
    database=$2
    output=$database.v$(date +%Y%m%d).sql

    # don't use -p$password in order to avoid message in ouyput "mysqldump: [Warning] Using a password on the command line..."
    # --env-file=configs/mysql_root.env
    docker exec --env-file=configs/mysql.env -it $container \
      mysqldump -u root --databases $database > $output

    pigz $output
    echo "==> saved ${output}.gz"
    ;;
"restore")
    gz_file=$2

    mkdir -p data
    pigz -dc $gz_file > data/temp.sql
    docker cp data/temp.sql $container:/
    rm data/temp.sql

    docker exec --env-file=configs/mysql.env -it mysql bash -c 'mysql -u root -p$MYSQL_PWD'
    docker exec $container rm /temp.sql
    ;;
*)
    >&2 echo "==> nothing todo!"
    exit 1
;;
esac
