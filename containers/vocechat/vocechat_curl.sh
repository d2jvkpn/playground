#!/bin/bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

#### 1. setup
command -v jq > /dev/null ||  { echo "can't find jq"; exit 1; }
command -v yq > /dev/null ||  { echo "can't find yq"; exit 1; }

[[ $# -eq 0 ]] && { >&2 echo "Pass your message as argument(s)!"; exit 1; }
msg="$*"

#### 2. config
yaml=${yaml:-configs/local.yaml}
server=$(yq .server $yaml)

api_key=$(yq .api_key $yaml)

email=$(yq .email $yaml)
password=$(yq .password $yaml)

ua="Mozilla/5.0 Gecko/20100101 Firefox/130.0"

#### 3. bot send msg to user
echo "==> 1. sending to user: $msg"

curl -i -k -H "User-Agent: $ua" -H "Origin: $server" -H "x-api-key: $api_key" \
  -X POST "$server/api/bot/send_to_user/1" \
  -H 'Content-Type: text/plain' --data-raw "$msg"

#### 4. bot send msg to group
exit
echo "==> 2. sending to group: $message"

curl -i -k -H "User-Agent: $ua" -H "Origin: $server" -H "x-api-key: $api_key"
  -X POST "$server/api/bot/send_to_group/1"
  -H 'Content-Type: text/plain' --data-raw "$msg"

#### 4. user login
data=$(
  jq -n --arg email "$email" --arg password "$password" \
    '{credential:{email:$email,password:$password,type:"password"}}'
)
# expired_in: 30
# refresh_token: xxxx.xxxx.xxxx

echo "==> 3. login"

token=$(
  curl -k -H "User-Agent: $ua" -H "Origin: $server" -H "Referer: $server" \
    -X POST "$server/api/token/login" \
    -H 'Content-Type: application/json' --data-raw "$data" |
    jq -r .token
)

#### 5. user send msg to user
echo "==> 2. sending to user: $msg"

curl -i -k -X POST -H "User-Agent: $ua" -H "Origin: $server" -H "Referer: $server" \
  -H "X-API-Key: $token"  \
  -X POST "$server/api/user/1/send" \
  -H 'Content-Type: text/plain' -d "$msg"
