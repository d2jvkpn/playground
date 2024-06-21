#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})


db=$1
shift
tables=$@

tag=$(date +%F-%s)

MYSQL_PWD=password4user \
  mysqldump -u root --complete-insert --skip-extended-insert \
  $db $tables  > migration_mysql.$tag.sql
# --no-create-info

awk '/^INSERT/ || $1==""{
  gsub("`", "");
  gsub(/\\/, "");
  sub(";$", " on conflict do nothing;");
  print;
}' migration_mysql.$tag.sql > migration_postgres.$tag.sql
