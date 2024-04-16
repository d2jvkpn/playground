#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

cd "${_path}"

container=$(yq .services.mysql.container_name docker-compose.yaml)

docker exec --env-file=configs/mysql.env -it $container bash -c 'mysql -u root -p$MYSQL_PWD'
