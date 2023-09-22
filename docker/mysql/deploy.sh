#! /usr/bin/env bash
set -eu -o pipefail

export PORT=3306
envsubst < $(dirname $0)/deploy.yaml > docker-compose.yaml

mkdir -p data/mysql
docker-compose pull
docker-compose up -d

exit

docker exec -it mysql_db mysql -u root -p

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
