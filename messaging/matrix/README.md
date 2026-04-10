# Matrix
---
```meta
date: 1970-01-01
authors: []
version: 0.1.0
```


#### ch01. 
1. docs
- https://github.com/element-hq/synapse
- https://hub.docker.com/r/matrixdotorg/synapse
- https://hub.docker.com/r/vectorim/element-web
- https://github.com/element-hq/element-web
- https://github.com/element-hq/element-web/blob/develop/docs/config.md#desktop-app-configuration

2. images
- matrixdotorg/synapse:v1.151.0
- vectorim/element-web:v1.12.15

3. generate
```
server_name=$(yq .synapse.server_name configs/synapse.yaml)
mkdir -p data/synapse

docker run -it --rm \
  -v $PWD/data/synapse:/data \
  -e SYNAPSE_SERVER_NAME=$server_name \
  -e SYNAPSE_REPORT_STATS=yes \
  -e SYNAPSE_HTTP_PORT=8008 \
  -e SYNAPSE_CONFIG_DIR=/data \
  -e SYNAPSE_CONFIG_PATH=/data/homeserver.yaml \
  -e SYNAPSE_DATA_DIR=/data \
  -e UID=$(id -u) \
  -e GID=$(id -g) \
  matrixdotorg/synapse:latest generate
```

4. create database
```
CREATE ROLE synapse WITH LOGIN PASSWORD 'xxxxxxxx';

CREATE DATABASE synapse with owner = synapse
  ENCODING 'UTF8' LC_COLLATE 'C' LC_CTYPE 'C' TEMPLATE template0;
```

5. config database in data/synapse/homeserver.yaml
```
database:
  name: sqlite3
  args:
    database: /data/homeserver.db
```

```
database:
  name: psycopg2
  args:
    host: postgres
    port: 5432
    user: synapse
    password: change_me_strong_password
    database: synapse
    cp_min: 5
    cp_max: 10
````

6. create accounts
```
docker exec -it synapse register_new_matrix_user http://localhost:8008 -c /data/homeserver.yaml --help

user=$(yq .synapse.user configs/synapse.yaml)
password=$(yq .synapse.password configs/synapse.yaml)

docker exec -it synapse register_new_matrix_user http://localhost:8008 \
  --config /data/homeserver.yaml --admin \
  --user "$user" --password "$password"
``

7. desktop
- https://element.io/en/download#linux
```
sudo apt install -y wget apt-transport-https
‍
sudo wget -O /usr/share/keyrings/element-io-archive-keyring.gpg https://packages.element.io/debian/element-io-archive-keyring.gpg
‍
echo "deb [signed-by=/usr/share/keyrings/element-io-archive-keyring.gpg] https://packages.element.io/debian/ default main" | sudo tee /etc/apt/sources.list.d/element-io.list

sudo apt update

sudo apt install element-desktop
```

8. misc
```
docker run --name synapse -v $PWD/data/synapse:/data -p 8008:8008 matrixdotorg/synapse:latest

docker run --name element-web -v $PWD/configs/element-web.json:/app/config.json \
  -p 8007:80 vectorim/element-web:latest
```
