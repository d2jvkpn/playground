#!/usr/bin/env bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


# echo "Hello, world!"
db=${1:-postgres}
tag=$(date +%F-%s)

mkdir -p temp

docker exec postgres \
  pg_dump --host=localhost --port=5432 --username=postgres \
  --verbose --format=plain --no-owner \
  --inserts --rows-per-insert=1000 --column-inserts \
  $db > temp/$db.$tag.sql

exit
docker exec postgres \
  pg_dump --host=localhost --port=5432 --username=postgres \
  --verbose --format=plain --no-owner \
  --schema-only \
  $db | sed 's/\t/  /g' > temp/$db.schema.sql

# --column-inserts, --table $t1 --table $t2
docker exec postgres \
  pg_dump --host=localhost --port=5432 --username=postgres \
  --verbose --format=plain --no-owner \
  --data-only --inserts --rows-per-insert=100 --on-conflict-do-nothing \
  $db | sed 's/\t/  /g' > temp/$db.data.sql
