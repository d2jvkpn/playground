#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


####
port=${port:-9201}
container=${1:-elastic01}
kibana=$2

pass_file=configs/$container/elastic.pass
addr="https://localhost:$port"
echo "==> addr: $addr"

####
token=$(
  docker exec -it $container \
    elasticsearch-create-enrollment-token -s kibana --url https://localhost:9200 |
    dos2unix
)

[ ! -s $pass_file ] &&
  docker exec -it $container elasticsearch-reset-password --batch -u elastic |
  awk '/New value:/{print $NF}' |
  dos2unix > $pass_file

password=$(cat $pass_file)
[ -z "$password" ] && { >&2 echo "failed to run elasticsearch-reset-password "; exit 1; }

#code=$(cat data/$kibana/verification_code)
code=$(docker exec -it $kibana cat data/verification_code)

cat <<EOF
created_at: $(date +%FT%T%:z)
enrollment_token: $token
verification_code: $code
account: elastic
password: $password
EOF
