#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


choice=${1:-postgres}

export PGHOST=$(yq .host configs/postgres.yaml)
export PGPORT=$(yq .port configs/postgres.yaml)
export PGDATABASE=$(yq ".choices.$choice.database" configs/postgres.yaml)
export PGUSER=$(yq ".choices.$choice.user" configs/postgres.yaml)

export PGPASSFILE=configs/pgpass_files/$choice.pgpass

if [ -f "$PGPASSFILE" ]; then
    password=$(yq ".choices.$choice.password" configs/postgres.yaml)
    mkdir -p configs/pgpass_files
    echo "$PGHOST:$PGPORT:$PGDATABASE:$PGUSER:$password" > $PGPASSFILE
fi

echo "==> Connecting to: host=$PGHOST port=$PGPORT dbname=$PGDATABASE user=$PGUSER"
psql

exit
configs/postgres.yaml

```yaml
host: 10.1.1.2
port: 5432
choices:
  postgres: { user: postgres, database: postgres, password: xxxxxxxx }
```
