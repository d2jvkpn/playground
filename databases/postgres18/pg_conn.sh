#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


choice=${1:-postgres}

config=${config:-./configs/postgres.yaml}
if [ ! -f $config ]; then
    config=$HOME/.config/postgres/postgres.yaml
fi
config_dir=$(dirname $config)

host=$(yq .host "$config")                            # PGHOST
port=$(yq .port "$config")                            # PGPORT
database=$(yq ".choices.$choice.database" "$config")  # PGDATABASE
user=$(yq ".choices.$choice.user" "$config")          # PGUSER

export PGPASSFILE=$config_dir/$choice.pgpass

if [ ! -f "$PGPASSFILE" ]; then
    password=$(yq ".choices.$choice.password" configs/postgres.yaml)
    mkdir -p "$config_dir"
    echo "$PGHOST:$PGPORT:$PGDATABASE:$PGUSER:$password" > "$PGPASSFILE"
    chmod 600 "$PGPASSFILE"
fi

echo "[$(date +%FT%T%:z)] pg_conn.sh: host=$host port=$port dbname=$database user=$user" >&2

if [[ $# -eq 0 ]]; then
    psql "host=$host port=$port dbname=$database user=$user"
else
    shift
    psql "host=$host port=$port dbname=$database user=$user" "$@"
fi

exit

## Config file
- path: configs/postgres.yaml, ~/.config/postgres.yaml
- example:
```yaml
host: 10.1.1.2
port: 5432
choices:
  postgres: { user: postgres, database: postgres, password: xxxxxxxx }
```

## Usage
- psql shell: pg_conn.sh postgres
- psql execute: pg_conn.sh postgres -t -A -c "select current_database();"
