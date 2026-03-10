#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


#####
exit
hook_id=$(yq .feishu.hook.id configs/feishu.yaml)

curl -X POST "https://open.feishu.cn/open-apis/bot/v2/hook/$hook_id" \
  -H 'Content-Type: application/json' \
  -d '{"msg_type": "text", "content": { "text": "This is a test" }, "timeout": 30}'
