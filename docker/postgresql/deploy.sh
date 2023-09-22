#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

export PORT=5432
envsubst < $(dirname $0)/deploy.yaml > docker-compose.yaml

docker-compose pull
docker-compose up -d

exit

docker exec -it postgres_db psql --username postgres --password postgres

psql --host 127.0.0.1 --port 5432 --username postgres --password postgres

```postgres
alter user postgres with password 'XXXXXXXX';

create user hello with password 'world';
create database db01 with owner = hello;
```

#### set json log
docker exec postgres_db bash -c \
  "echo -e '\nlog_destination = jsonlog\nlogging_collector = on' >> /var/lib/postgresql/data/pgdata/postgresql.conf"

docker-compose down
docker-compose up

docker exec postgres_db ls /var/lib/postgresql/data/pgdata/log/
