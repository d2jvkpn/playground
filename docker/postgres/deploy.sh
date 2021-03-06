#! /usr/bin/env bash
set -eu -o pipefail

_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

export APP_Tag=${1:-dev} PORT=${2:-5432}

####
container=postgres_${APP_Tag}

found=$(docker ps -a | awk -v c=$container 'NR>1 && $NF==c{print 1; exit}')
[ ! -z $found ] && { >&2 echo '!!! '"container $container exists" ; exit 1; }

template='''version: "3"

services:
  postgres:
    image: postgres:16-alpine
    container_name: postgres_${APP_Tag}
    restart: always
    healthcheck:
      test: pg_isready --username postgres --database postgres
      start_period: 10s
      interval: 30s
      timeout: 3s
      retries: 3
    # network_mode: bridge
    networks: ["net"]
    ports: ["127.0.0.1:${PORT}:5432"]
    environment:
    - TZ=Asia/Shanghai
    - PGTZ=Asia/Shanghai
    - POSTGRES_USER=postgres
    - POSTGRES_DB=postgres
    - POSTGRES_PASSWORD=postgres
    # - POSTGRES_PASSWORD_FILE=/run/secrets/postgres-passwd
    - PGDATA=/var/lib/postgresql/data
    volumes:
    # - data:/var/lib/postgresql/data
    - ./data/postgres:/var/lib/postgresql/data
    # - ./configs/postgresql.conf:/var/lib/postgresql/data/pgdata/postgresql.conf
    # - ./configs/pg_hba.conf:/var/lib/postgresql/data/pgdata/pg_hba.conf

# volums:
#   data: { name: postgres_storage, driver: local }

networks:
  net: { name: "postgres_${APP_Tag}", driver: "bridge", external: false }'''

# envsubst < ${_path}/deploy.yaml > docker-compose.yaml
echo "$template" | envsubst > docker-compose.yaml
mkdir -p configs data/postgres

secret_file=configs/postgres.secret
if [ ! -s "$secret_file" ]; then
    tr -dc 'a-zA-Z0-9' < /dev/urandom |
      fold -w 32 |
      head -n1 > "$secret_file" || true

    echo "==> create secret $secret_file"
else
    echo "==> using existing secret $secret_file"
fi
password=$(cat $secret_file)
 
# docker-compose pull
echo "==> starting container $container"
docker-compose up -d

####
n=0; abort=""
echo "==> container $container: the database is initializing"

while ! docker exec $container pg_isready -U postres -d postres &> /dev/null; do
    sleep 1; echo -n "."

    n=$((n+1)); [ $((n%60)) -eq 0 ] && echo ""
    [ $n -ge 300 ] && { abort="true"; break; }
done
echo -e "\n==> $((n/60))m$((n%60))s elapsed\n"
[ ! -z "$abort" ] && { >&2 echo '!!! abort'; exit 1; }

####
echo "==> change password of postgres"

# docker exec -it -u postgres -w /var/lib/postgresql/data/ $container bash
# docker exec -i -u postgres $container psql -c "ALTER USER user_name WITH PASSWORD '$password'"
printf "$password\r\n$password\r\n" |
  docker exec -i -u postgres $container psql -x -c '\password postgres'

####
echo "==> restart container $container"

docker exec -u postgres -w /var/lib/postgresql/data/ $container bash -c \
  "cp pg_hba.conf pg_hba.conf.bk && \
  sed -i 's/trust$/scram-sha-256/' pg_hba.conf && \
  cp postgresql.conf postgresql.conf.bk && \
  echo -e '\nlog_destination = jsonlog\nlogging_collector = on' >> postgresql.conf"

docker-compose down
docker-compose up -d

exit
####
container=$(yq .services.postgres.container_name docker-compose.yaml)

docker cp $container:/var/lib/postgresql/data/postgresql.conf configs/
docker cp $container:/var/lib/postgresql/data/pg_hba.conf configs/

docker exec -it $container psql --username postgres --password postgres

docker exec -it --user postgres $container psql --password postgres

psql --host 127.0.0.1 --port 5432 --username postgres --password postgres

```postgres
alter user postgres with password 'XXXXXXXX';

create user hello with password 'world';
create database hello with owner = hello;
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

#### add user hello
exit
docker exec -it postgres_dev createuser --username=postgres hello --createdb --login
docker exec -it postgres_dev psql --username=postgres -c 'create database hello with owner=hello'
# docker exec -it postgres_dev psql --username=postgres -c 'grant all privileges on database hello to hello'
# docker exec -it postgres_dev psql --username=postgres -c "ALTER ROLE hello PASSWORD 'world'"
docker exec -it postgres_dev psql --username=postgres -c "\password hello"

docker exec -it postgres_dev psql --username=hello
