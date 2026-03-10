#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


choice=${1:-postgres}

config=./configs/postgres.yaml
if [ ! -f $config ]; then
    config=$HOME/.config/postgres.yaml
fi
config_dir=$(dirname $config)

host=$(yq .host "$config")                            # PGHOST
port=$(yq .port "$config")                            # PGPORT
database=$(yq ".choices.$choice.database" "$config")  # PGDATABASE
user=$(yq ".choices.$choice.user" "$config")          # PGUSER

export PGPASSFILE=$config_dir/pgpass_files/$choice.pgpass

if [ ! -f "$PGPASSFILE" ]; then
    password=$(yq ".choices.$choice.password" configs/postgres.yaml)
    mkdir -p "$config_dir"
    echo "$PGHOST:$PGPORT:$PGDATABASE:$PGUSER:$password" > "$PGPASSFILE"
    chmod 600 "$PGPASSFILE"
fi

echo "==> Connecting to: host=$host port=$port dbname=$database user=$user"
psql "host=$host port=$port dbname=$database user=$user"

exit

config_file: configs/postgres.yaml or ~/.config/postgres.yaml
```yaml
host: 10.1.1.2
port: 5432
choices:
  postgres: { user: postgres, database: postgres, password: xxxxxxxx }
```
