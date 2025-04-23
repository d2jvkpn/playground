#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


container=$1; account=$2

touch configs/es.yaml

password=$(
  docker exec -it $container elasticsearch-reset-password --batch -u "$account" |
    awk '/New value:/{print $NF}' |
    dos2unix
)

if [ -z "$password" ]; then
    echo '!!! Failed to run elasticsearch-reset-password'
    exit 1
fi

yq eval '.'$account' = "'$password'"' -i configs/es.yaml

echo "==> Updated file: configs/es.yaml"
