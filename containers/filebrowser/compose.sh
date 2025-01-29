#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

HTTP_Port=${1:-3020}

#### 1.
mkdir -p configs logs data/filebrowser

[ -s configs/filebrowser.json ] || \
cat > configs/filebrowser.json <<EOF
{
  "port": $HTTP_Port,
  "baseURL": "",
  "address": "",
  "log": "/app/logs/filebrowser.log",
  "database": "/app/data/filebrowser.db",
  "root": "/app/data/filebrowser"
}
EOF

#### 2.
export HTTP_Port=$HTTP_Port USER_UID=$(id -u) USER_GID=$(id -g)

envsubst < compose.template.yaml > compose.yaml

#### 3.
docker-compose pull
docker-compose up -d

exit

cat <<EOF
# default account
username: admin
password: admin
EOF

cat >> .filebrowser.json <<EOF
{
  "port": 80,
  "baseURL": "",
  "address": "",
  "log": "stdout",
  "database": "/database.db",
  "root": "/srv"
}
EOF

docker run --rm -it --entrypoint=sh filebrowser/filebrowser:v2

docker run \
    -v /path/to/root:/srv \
    -v /path/to/filebrowser.db:/database.db \
    -v /path/to/.filebrowser.json:/.filebrowser.json \
    -u $(id -u):$(id -g) \
    -p 8080:80 \
    filebrowser/filebrowser:v2
