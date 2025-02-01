#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


mkdir -p data/gotify

docker-compose -f compose.template.yaml up -d

exit
# GOTIFY_SERVER_PORT=8030 ./gotify-linux-amd64
# default: { account: admin, password: admin }

curl -X 'POST' \
  'http://localhost:8030/user' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "admin": true,
  "name": "unicorn",
  "pass": "nrocinu"
}'

curl "http://localhost:8030/message?token=$token" \
  -F "priority=10" \
  -F "title=A Test" \
  -F "message=Hello, world, $(date +%FT%T%:z)!"
