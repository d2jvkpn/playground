#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

database=$1

container=$(yq .services.mysql.container_name docker-compose.yaml)
password=$(cat configs/mysql_root.password)

output=$database.v$(date +%Y%m%d).sql
docker exec -it $container mysqldump -u root -p$password --databases $database > $output

pigz $output
