#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})
# set -x

export APP_Tag=${1:-dev} PORT=${2:-3306}
container=mysql_${APP_Tag}

envsubst < ${_path}/deploy.yaml > docker-compose.yaml

mkdir -p configs data/mysql

if [ ! -s configs/mysql.secret ]; then
    tr -dc 'a-zA-Z0-9' < /dev/urandom |
      fold -w 32 |
      head -n1 > configs/mysql.secret || true
      echo "==> create secret configs/mysql.secret"
else
    echo "==> using existing secret configs/mysql.secret"
fi
password=$(cat configs/mysql.secret)

cat > configs/mysql.env <<EOF
export MYSQL_ROOT_PASSWORD=$password
EOF

# docker-compose pull
docker-compose up -d

echo "==> sleep 5"
sleep 5

docker-compose down
sed -i '/mysql.env/d' docker-compose.yaml
docker-compose up -d

rm configs/mysql.env

exit

container=$(yq .services.mysql.container_name docker-compose.yaml)
docker exec -it $container mysql -u root -p

# sudo apt install -y mysql-client

mysql -h 127.0.0.1 -P ${PORT:-3306} -u root -pmysql \
  -e "ALTER USER 'root'@'%' IDENTIFIED BY '$password'; FLUSH PRIVILEGES"

mysql -h 127.0.0.1 -P ${PORT:-3306} -u root -p

```mysql
--
SELECT user, host, account_locked FROM mysql.user;

ALTER USER 'root'@'localhost' IDENTIFIED BY 'XXXXXXXX';
ALTER USER 'root'@'%' IDENTIFIED BY 'XXXXXXXX';

CREATE DATABASE IF NOT EXISTS db01 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE USER 'hello'@'%' IDENTIFIED BY 'XXXXXXXX';
GRANT ALL PRIVILEGES ON db01.* TO 'hello'@'%';
FLUSH PRIVILEGES;

USE db01;
```
