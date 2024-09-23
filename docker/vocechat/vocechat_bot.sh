#!/bin/bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

#### 1.
# command -v jq > /dev/null ||  { echo "can't find jq"; exit 1; }
command -v yq > /dev/null ||  { echo "can't find yq"; exit 1; }

[[ $# -eq 0 ]] && { >&2 echo "Pass your message as argument(s)!"; exit 1; }
message="$*"

#### 2.
yaml=${yaml:-configs/local.yaml}
server=$(yq .server $yaml)
api_key=$(yq .bot.api_key $yaml)
send_to_user=$(yq .bot.send_to_user $yaml)

ua="Mozilla/5.0 Gecko/20100101 Firefox/130.0"

#### 3.
echo "==> 1. sending to user: $message"

curl -i -k -H "User-Agent: $ua" -H "Origin: $server" -H "x-api-key: $api_key" \
  -X POST "$server/api/bot/send_to_user/$send_to_user" \
  -H 'Content-Type: text/plain' --data-raw "$message"

####
exit
send_to_group=$(yq .bot.send_to_group $yaml)

echo "==> 2. sending to group: $message"

curl -i -k -H "User-Agent: $ua" -H "Origin: $server" -H "x-api-key: $api_key"
  -X POST "$server/api/bot/send_to_group/$send_to_group"
  -H 'Content-Type: text/plain' --data-raw "$message"
