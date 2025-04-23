#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


####
container=$1; kibana=$2

####
token=$(
  docker exec -it $container \
    elasticsearch-create-enrollment-token -s kibana --url https://localhost:9200 |
    dos2unix
)

#code=$(cat data/$kibana/verification_code)
code=$(docker exec -it $kibana cat data/verification_code)

cat <<EOF
enrollment_token: $token
verification_code: $code
EOF
