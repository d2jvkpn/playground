#!/bin/bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

#### 1.
command -v jq > /dev/null ||  { echo "can't find jq"; exit 1; }
command -v yq > /dev/null ||  { echo "can't find yq"; exit 1; }

[[ $# -eq 0 ]] && { >&2 echo "Pass your message as argument(s)!"; exit 1; }
message="$*"

#### 2.
yaml=${yaml:-configs/local.yaml}
server=$(yq .server $yaml)
email=$(yq .user.email $yaml)
password=$(yq .user.password $yaml)
send_to_user=$(yq .user.send_to_user $yaml)

ua="Mozilla/5.0 Gecko/20100101 Firefox/130.0"

#### 3.
set -x

data=$(
  jq -n --arg email "$email" --arg password "$password" \
    '{credential:{email:$email,password:$password,type:"password"}}'
)
# expired_in: 30
# refresh_token: xxxx.xxxx.xxxx

echo "==> 1. login"

token=$(
  curl -k -H "User-Agent: $ua" -H "Origin: $server" -H "Referer: $server" \
    -X POST "$server/api/token/login" \
    -H 'Content-Type: application/json' --data-raw "$data" |
    jq -r .token
)

#### 4.
echo "==> 2. sending to user: $message"

curl -i -k -X POST -H "User-Agent: $ua" -H "Origin: $server" -H "Referer: $server" \
  -H "X-API-Key: $token"  \
  -X POST "$server/api/user/$send_to_user/send" \
  -H 'Content-Type: text/plain' -d "$message"
