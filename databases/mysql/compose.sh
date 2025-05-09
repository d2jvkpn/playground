#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `$dirname "$0"`)

export DB_Port=${1:-3306} CONTAINER_Name=${2:-mysql}
user=${user:-d2jvkpn}

mkdir -p configs data/mysql data/temp

[ -s configs/mysql_root.password ] || \
  tr -dc 'a-zA-Z0-9' < /dev/urandom | fold -w 32 | head -n1 > configs/mysql_root.password || true

db_root_password=$(cat configs/mysql_root.password)
db_user_password=$(tr -dc 'a-zA-Z0-9' < /dev/urandom | fold -w 32 | head -n1 || true)

#### WHY: set MYSQL_PWD in mysql.env will make can't login as root
[ -s configs/mysql.env ] || \
cat > configs/mysql.env <<EOF
MYSQL_USER=$user
MYSQL_DATABASE=$user
MYSQL_PASSWORD=$db_user_password
EOF

envsubst < ${_dir}/compose.mysql.yaml > compose.yaml

# docker-compose pull
docker-compose up -d

exit

####
n=0; abort=""
echo "==> container $container: the database is initializing"

# while [ $(docker logs $container 2>&1 | grep -c "InnoDB initialization has ended.") -eq 0 ]; do
while ! printf "$password\n" | docker exec -i $container \
  mysql -u root -p -e "select 'Hello, world'" &> /dev/null; do
    sleep 1; echo -n "."

    n=$((n+1)); [ $((n%60)) -eq 0 ] && echo ""
    [ $n -ge 300 ] && { abort="true"; break; }
done
echo -e "\n==> $((n/60))m$((n%60))s elapsed\n"
[ ! -z "$abort" ] && { >&2 echo '!!! abort'; exit 1; }

####
echo "==> restart container $container"
sed -i 's/    env_file: /    # env_file: /' compose.yaml
rm configs/mysql.env

docker-compose down
docker-compose up -d

exit

container=$(yq .services.mysql.container_name compose.yaml)
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

--
select Host, User, password_last_changed from mysql.user;
```
