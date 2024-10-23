#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

app_dir=~/.local/apps/chatgpt
mkdir -p $app_dir/data
# ChatGPT_Token=Your_OPENAI_API_Key
[ -f $app_dir/env ] && source $app_dir/env
https_proxy=${https_proxy:-""}
proxy=""; [ -z "$https_proxy" ] || proxy="-x $https_proxy"

# CURL_Proxy='-x socks5h://localhost:1081'
curl https://api.openai.com/v1/models ${proxy} \
  -H "Authorization: Bearer $ChatGPT_Token" > OpenAI_Models.$(date +%s-%F).json
  # -H "OpenAI-Organization: $OPENAI_ORG_ID" > OpenAI_Models.json

exit
jq '.data | sort_by(.created) | reverse' OpenAI_Models.json |
  less
