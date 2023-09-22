#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

command -v jq > /dev/null ||  { echo "can't find jq"; exit 1; }
command -v yq > /dev/null ||  { echo "can't find yq"; exit 1; }

[[ $# -eq 0 ]] && { >&2 echo "Pass your message as argument(s)!"; exit 1; }
message="$*"

config=${VoceChat_Config-config.yaml}
server=$(yq .server $config)
email=$(yq .email $config)
password=$(yq .password $config)
send_to=$(yq .send_to $config)


data=$(jq -n --arg email "$email" --arg password "$password" \
  '{credential:{email:$email,password:$password,type:"password"}}')

token=$(curl -k -X POST "$server/api/token/login" -H "Referer: $server" \
  -H 'Content-Type: application/json' --data-raw "$data" | jq -r .token)

curl -k -L -X POST "$server/api/user/$send_to/send" \
  -H "X-API-Key: $token"        \
  -H 'Content-Type: text/plain' \
  -d "$message"

curl -k -L -X POST "$server/api/group/$send_to/send" \
  -H "X-API-Key: $token"        \
  -H 'Content-Type: text/plain' \
  -d "$message"
