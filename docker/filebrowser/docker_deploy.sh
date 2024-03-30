#! /usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

HTTP_Port=${1:-3020}

export HTTP_Port=$HTTP_Port
export USER_UID=$(id -u) USER_GID=$(id -g)

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

envsubst < docker_deploy.yaml > docker-compose.yaml

docker-compose pull
docker-compose up -d


exit
default username: admin
default password: admin

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
    -v /path/filebrowser.db:/database.db \
    -v /path/.filebrowser.json:/.filebrowser.json \
    -u $(id -u):$(id -g) \
    -p 8080:80 \
    filebrowser/filebrowser:v2
