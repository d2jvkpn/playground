#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

exit

bot_id=$(yq .bot01.id configs/feishu.yaml)

timestamp=$(date +%FT%T%:z)
event_id=$(uuid)
curl --fail "https://www.feishu.cn/flow/api/trigger-webhook/${bot_id}?timestamp=${timestamp}&event_id=${event_id}&content=Hello_world!"
