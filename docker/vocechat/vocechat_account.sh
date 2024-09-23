#!/bin/bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

command -v jq > /dev/null ||  { echo "can't find jq"; exit 1; }
command -v yq > /dev/null ||  { echo "can't find yq"; exit 1; }

[[ $# -eq 0 ]] && { >&2 echo "Pass your message as argument(s)!"; exit 1; }
message="$*"

yaml=${yaml:-configs/vocechat.yaml}
server=$(yq .server $yaml)
email=$(yq .account.email $yaml)
password=$(yq .account.password $yaml)
send_to_user=$(yq .send_to_user $yaml)

data=$(
  jq -n --arg email "$email" --arg password "$password" \
    '{credential:{email:$email,password:$password,type:"password"}}'
)

token=$(
  curl -k -X POST "$server/api/token/login" -H "Referer: $server" \
    -H 'Content-Type: application/json' --data-raw "$data" |
    jq -r .token
)

curl -k -L -X POST "$server/api/user/$send_to_user/send" \
  -H "X-API-Key: $token"        \
  -H 'Content-Type: text/plain' \
  -d "$message"

curl -k -L -X POST "$server/api/group/$send_to_user/send" \
  -H "X-API-Key: $token"        \
  -H 'Content-Type: text/plain' \
  -d "$message"
