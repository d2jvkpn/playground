#!/bin/bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

command -v jq > /dev/null ||  { echo "can't find jq"; exit 1; }
command -v yq > /dev/null ||  { echo "can't find yq"; exit 1; }

[[ $# -eq 0 ]] && { >&2 echo "Pass your message as argument(s)!"; exit 1; }
message="$*"

config=${VoceChat_Config-config.yaml}
server=$(yq .server $config)
api_key=$(yq .api_key $config)
send_to=$(yq .send_to $config)

echo ">>> sending: $message"
curl -k -X POST "$server/api/bot/send_to_user/$send_to" \
  -H "X-API-Key: $api_key"      \
  -H 'Content-Type: text/plain' \
  -d "$message"

echo ">>> sending: $message"
curl -k -X POST "$server/api/bot/send_to_group/$send_to" \
  -H "X-API-Key: $api_key"      \
  -H 'Content-Type: text/plain' \
  -d "$message"
