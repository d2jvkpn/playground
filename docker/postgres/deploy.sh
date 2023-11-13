#! /usr/bin/env bash
set -eu -o pipefail

_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

export APP_Tag=${1:-dev} PORT=${2:-5432}

####
container=postgres_${APP_Tag}
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

envsubst < ${_path}/deploy.yaml > docker-compose.yaml
 
# docker-compose pull
echo "==> starting container $container"
docker-compose up -d

####
n=0; abort=""
echo "==> container $container: the database is initializing"

while ! docker exec $container pg_isready -U postres -d postres &> /dev/null; do
    sleep 1; echo -n "."; n=$((n+1))
    [ $((n%60)) -eq 0 ] && echo ""
    [ $n -ge 180 ] && { abort="true"; break; }
done
echo -e "\n$n second(s) elapsed\n"
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
  "cp pg_hba.conf pg_hba.conf.bk && sed -i 's/trust$/scram-sha-256/' pg_hba.conf"

docker exec -u postgres -w /var/lib/postgresql/data/ $container bash -c \
  "cp postgresql.conf postgresql.conf.bk && \
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
