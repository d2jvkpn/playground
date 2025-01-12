#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


container=${container:-elastic01}

token=$(
  docker exec -it $container bash -c \
    "elasticsearch-create-enrollment-token -s kibana --url https://localhost:9200" |
    dos2unix
)

code=$(cat data/kibana/verification_code)

cat <<EOF
kibana:
  token: $token
  code: $code
EOF
