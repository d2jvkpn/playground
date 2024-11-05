#!/bin/bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

export DB_PORT=$1
user=${user:-hello}; db=${user:-app}

db_root_password=$(tr -dc "0-9a-zA-Z" < /dev/urandom | fold -w 32 | head -n 1 || true)
db_user_password=$(tr -dc "0-9a-zA-Z" < /dev/urandom | fold -w 32 | head -n 1 || true)

[ -s configs/mariadb.env ] || \
cat > configs/mariadb.env <<EOF
MARIADB_ROOT_PASSWORD=$db_root_password
MARIADB_PASSWORD=$db_user_password
MARIADB_USER=$user
MARIADB_DATABASE=$db
EOF

mkdir -p data/mariadb
envsubst < ${_path}/docker_deploy.yaml > docker-compose.yaml

docker-compose pull
docker-compose up -d

exit

docker exec -it mariadb mysql -u root -p

```mysql
--
SELECT user, host FROM mysql.user;

ALTER USER 'root'@'localhost' IDENTIFIED BY 'XXXXXXXX';
ALTER USER 'root'@'%' IDENTIFIED BY 'XXXXXXXX';

CREATE DATABASE IF NOT EXISTS db01;

CREATE USER 'hello'@'%' IDENTIFIED BY 'XXXXXXXX';
GRANT ALL PRIVILEGES ON db01.* TO 'hello'@'%';
FLUSH PRIVILEGES;

USE db01;
```
