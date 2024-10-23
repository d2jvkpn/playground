#! /usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

app_dir=~/.local/apps/chatgpt
mkdir -p $app_dir/data
# ChatGPT_Token=Your_OPENAI_API_Key
[ -f $app_dir/env ] && source $app_dir/env

output=OpenAI_Models.$(date +%s-%F).json

curl --silent https://api.openai.com/v1/models ${CURL_Proxy:-} \
  -H "Authorization: Bearer $ChatGPT_Token" > $output
  # -H "OpenAI-Organization: $OPENAI_ORG_ID" > OpenAI_Models.json

jq . $output

exit
jq '.data | sort_by(.created) | reverse' OpenAI_Models.json |
  less
