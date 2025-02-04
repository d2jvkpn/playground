#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


# sudo docker network create --driver=bridge --subnet=10.10.10.0/24 --gateway=10.10.10.1 matrix

mkdir -p configs data/postgres data/synapse

# https://develop.element.io/config.json
cat > configs/element.json <<EOF
{
  "default_server_config": {
    "m.homeserver": {
      "base_url": "https://matrix-client.matrix.org"
    },
    "m.identity_server": {
      "base_url": "https://vector.im"
    }
  }
}
EOF


docker run -it --rm \
  -v "$PWD/data/synapse:/data" \
  -e SYNAPSE_SERVER_NAME=matrix.example.com \
  -e SYNAPSE_REPORT_STATS=yes \
  matrixdotorg/synapse:latest generate

exit
database:
  name: psycopg2
  args:
    user: synapse
    password: STRONGPASSWORD
    database: synapse
    host: postgres
    cp_min: 5
    cp_max: 10
