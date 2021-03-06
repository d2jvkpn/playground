#! /usr/bin/env bash
set -eu -o pipefail

export MYSQL_ROOT_PASSWORD=$1
export PORT=$2
envsubst < $(dirname $0)/deploy.yaml > docker-compose.yaml

mkdir -p data/mariadb
docker-compose pull
docker-compose up -d

exit

docker exec -it maria_db mysql -u root -p

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
