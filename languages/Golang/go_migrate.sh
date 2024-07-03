#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

if ! command -v migrate; then
    # wget -P ~/Downloads https://github.com/golang-migrate/migrate/releases/download/v4.17.1/migrate.linux-amd64.tar.gz
    wget -P ~/Downloads https://github.com/golang-migrate/migrate/releases/download/latest/migrate.linux-amd64.tar.gz

    path=${1:-~/.local/bin}
    mkdir -p $path
    tar -xf  ~/Downloads/migrate.linux-amd64.tar.gz -C $path

    export PATH=$path:$PATH
fi

command -v migrate

. .env
migrate -path migrations/ -database $DATABASE_URL $@

exit
# update schema_migrations set version = 5, dirty = true;
force 5

# select version from schema_migrations limit 1;
# execute $version.down.sql
# update schema_migrations set version = version - 1;
down 1

####
exit

ls migrations/*.up.sql migrations/*.down.sql

migrate -path migrations/ -database $DATABASE_URL up
migrate -path migrations/ -database $DATABASE_URL force 1

migrate -path migrations/ -database $DATABASE_URL create -dir migrations -ext sql init
migrate -path migrations/ -database $DATABASE_URL drop -f

migrate -path migrations/ -database $DATABASE_URL force 15
