#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

# echo "Hello, world!"
db=${1:-postgres}

mkdir -p temp

docker exec postgres \
  pg_dump --host=localhost --port=5432 --username=postgres \
  --verbose --format=plain --no-owner \
  --inserts --rows-per-insert=100 --on-conflict-do-nothing \
   $db > temp/$db.sql

docker exec postgres \
  pg_dump --host=localhost --port=5432 --username=postgres \
  --verbose --format=plain --no-owner \
  --schema-only \
  $db > temp/$db.schema.sql

# --column-inserts, --table $t1 --table $t2
docker exec postgres \
  pg_dump --host=localhost --port=5432 --username=postgres \
  --verbose --format=plain --no-owner \
  --data-only --inserts --rows-per-insert=100 --on-conflict-do-nothing \
  $db > temp/$db.data.sql
