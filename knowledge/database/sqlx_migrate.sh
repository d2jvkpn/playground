#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

cargo install --version=0.7.1 sqlx-cli --no-default-features --features native-tls,postgres
command -v sqlx

export DATABASE_URL=postgres://hello:world@127.0.0.1:5432/users?sslmode=disable
echo "export DATABASE_URL=$DATABASE_URL" >> .env

psql --host=127.0.0.1 --port=5432 --username=hello --dbname users --password -c 'SELECT current_database()'

PGPASSWORD=pass1234 psql -Atx "host=127.0.0.1 port=5432 user=hello dbname=users sslmode=disable" -c 'select current_date'

PGPASSWORD=pass1234 psql -Atx postgresql://hello@127.0.0.1:5432/users?sslmode=disable -c 'select current_date'

PGPASSWORD=pass1234 psql -d postgresql://hello@127.0.0.1:5432/users?sslmode=disable -c 'select current_date'

sqlx database create
# sqlx database drop

sqlx migrate add init

sqls migrate run
