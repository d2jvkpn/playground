#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

export APP_Tag=${1:-dev} PORT=${2:-5432}

container=postgres_$APP_Tag
mkdir -p configs data/postgres

if [ ! -s configs/postgres.secret ]; then
    password=$(tr -dc 'a-zA-Z0-9' < /dev/urandom | fold -w 32 | head -n1 || true)
    echo $password > configs/postgres.secret
fi
password=$(cat configs/postgres.secret)

envsubst < ${_path}/deploy.yaml > docker-compose.yaml
 
# docker-compose pull
echo "==> starting container $container"
docker-compose up -d

n=0
while ! docker exec $container pg_isready -U postres -d postres; do
    echo "~~~ container $container isn't ready"
    sleep 1 && echo -n .
    n=$((n+1))
    [ $n -ge 30 ] && { '!!! abort'; exit 1; }
done

echo "==> change password of postgres"

# docker exec -it -u postgres -w /var/lib/postgresql/data/ $container bash
# docker exec -i -u postgres $container psql -c "ALTER USER user_name WITH PASSWORD '$password'"
printf "$password\r\n$password\r\n" |
  docker exec -i -u postgres $container psql -x -c '\password postgres'

echo "==> restart container $container"

docker exec -u postgres -w /var/lib/postgresql/data/ $container \
  cp pg_hba.conf pg_hba.conf.bk

docker exec -u postgres -w /var/lib/postgresql/data/ $container \
  sed -i 's/trust$/scram-sha-256/' pg_hba.conf

docker-compose down && docker-compose up -d

exit
container=$(yq .services.postgres.container_name docker-compose.yaml)

# docker exec -it $container psql --username postgres --password postgres
docker exec -it $container psql postgres://postgres@localhost:5432/postgres

####
docker cp $container:/var/lib/postgresql/data/postgresql.conf configs/
docker cp $container:/var/lib/postgresql/data/pg_hba.conf configs/

docker exec -it $container psql --username postgres --password postgres

docker exec -it --user postgres $container psql --password postgres

psql --host 127.0.0.1 --port 5432 --username postgres --password postgres

```postgres
alter user postgres with password 'XXXXXXXX';

create user hello with password 'world';
create database db01 with owner = hello;
```

#### config
sed -i '/trust$/s/trust$/scram-sha-256/' pg_hba.conf

cat >> pg_hba.conf <<EOF
# Add settings for extensions here
host    all    postgres    127.0.0.1/32    trust
host    all    postgres    ::1/128         trust
EOF

#### set json log
docker exec $container bash -c \
  "echo -e '\nlog_destination = jsonlog\nlogging_collector = on' >> /var/lib/postgresql/data/postgresql.conf"

docker-compose down
docker-compose up

docker exec $container ls /var/lib/postgresql/data/log/
