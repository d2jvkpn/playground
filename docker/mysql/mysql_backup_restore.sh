#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

action=$1

container=$(yq .services.mysql.container_name docker-compose.yaml)
password=$(cat configs/mysql_root.password)

case $action in
"backup")
    database=$2
    output=$database.v$(date +%Y%m%d).sql
    docker exec -it $container mysqldump -u root -p$password --databases $database > $output

    pigz $output
    echo "==> saved ${output}.gz"
    ;;
"restore")
    gz_file=$2

    mkdir -p data
    pigz -dc $gz_file data/temp.sql
    docker cp data/temp.sql $container:/
    rm data/temp.sql

    docker exec $container mysql -u root -p$password -e 'source /temp.sql'
    docker exec $container rm /temp.sql
    ;;
*)
    >&2 echo "==> nothing todo!"
    exit 1
;;
esac
