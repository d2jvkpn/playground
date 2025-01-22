#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


if [ ! -s configs/postgres.pass ]; then
    password=$(tr -dc '0-9a-zA-Z' < /dev/urandom | fold -w 32 | head -n 1 || true)
    echo "$password" > configs/postgres.pass
fi

# docker exec -it -u postgres postgres-node01 psql -c '\password'
password=$(awk '{print $1; exit}' configs/postgres.pass)

docker exec -u postgres postgres-node01 psql \
  -c "alter user postgres with encrypted password '$password';"
# \password postgres

exit
docker exec -it -u postgres postgres-node01 psql -x -c '\password postgres'
