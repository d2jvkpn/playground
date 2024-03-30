#!/bin/bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

mkdir -p logs
ls turnserver.conf

docker-compose pull
docker-compose up -d

exit

nohup turnserver --lt-cred-mech --fingerprint --verbose --mobility \
  --no-tls --no-dtls --new-log-timestamp --log-file=turnserver     \
  --realm=aaaa --user=aaaa:cccccccc                                \
  --external-ip=192.168.1.2 --listening-port 3478                  \
  --min-port=30000 --max-port=31000                                \
  --pidfile turnserver.pid
