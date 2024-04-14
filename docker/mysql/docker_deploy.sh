#!/bin/bash
set -eu -o pipefail #  -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

export DB_Port=${1:-3306}

container=mysql
found=$(docker ps -a | awk -v c=$container 'NR>1 && $NF==c{print 1; exit}')
[ ! -z $found ] && { >&2 echo '!!! '"container $container exists" ; exit 1; }

mkdir -p configs data/mysql

envsubst < ${_path}/docker_deploy.yaml > docker-compose.yaml

if [ ! -s configs/mysql.secret ]; then
    echo "==> creating secret configs/mysql.secret"

    tr -dc 'a-zA-Z0-9' < /dev/urandom | fold -w 32 | head -n1 > configs/mysql.secret || true
else
    echo "==> using then existing secret configs/mysql.secret"
fi
password=$(cat configs/mysql.secret)

cat > configs/mysql.env <<EOF
export MYSQL_ROOT_PASSWORD=$password
EOF

docker-compose pull
docker-compose up -d

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
sed -i 's/    env_file: /    # env_file: /' docker-compose.yaml
rm configs/mysql.env

docker-compose down
docker-compose up -d

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
