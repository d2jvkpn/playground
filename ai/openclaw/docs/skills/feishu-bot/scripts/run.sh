#!/usr/bin/env bash
set -euo pipefail

####
msg="${*:-}"
if [[ -z "$msg" ]]; then
    echo "Missing message text" >&2
    exit 2
fi
# echo $msg

config=${config:-$HOME/.config/feishu/feishu.yaml}

app_id=$(yq -r '.feishu.app_id // ""' "$config")
app_secret=$(yq -r '.feishu.app_secret // ""' "$config")
target_open_id=$(yq -r '.feishu.target_open_id // ""' "$config")

if [[ -z "$app_id" || -z "$app_secret" || -z "$target_open_id" ]]; then
    echo "Config missing one of: feishu.app_id, feishu.app_secret, feishu.target_open_id" >&2
    exit 2
fi

####
body=$(jq -n --arg app_id "$app_id" --arg app_secret "$app_secret" '{app_id:$app_id, app_secret:$app_secret}')

token_res=$(curl -fsSL -X POST \
  -H 'Content-Type: application/json' \
  -d "$body" \
  https://open.feishu.cn/open-apis/auth/v3/tenant_access_token/internal/ \
)

code=$(jq -r '.code // -1' <<<"$token_res")
if [[ "$code" != "0" ]]; then
    msg_res="$(jq -r '.msg // "token error"' <<<"$token_res")"
    echo "Failed to get tenant_access_token: code=$code, msg=$msg_res" >&2
    exit 1
fi

token=$(jq -r '.tenant_access_token' <<<"$token_res")

body="$(jq -n --arg rid "$target_open_id" --arg text "$msg" \
  '{receive_id:$rid, msg_type:"text", content:({text:$text}|tojson)}')"

send_res=$(curl -fsSL -X POST \
  -H 'Content-Type: application/json' \
  -H "Authorization: Bearer $token" \
  -d "$body" \
  'https://open.feishu.cn/open-apis/im/v1/messages?receive_id_type=open_id' \
)

code=$(jq -r '.code // -1' <<<"$send_res")
if [[ "$code" != "0" ]]; then
    msg_res="$(jq -r '.msg // "send error"' <<<"$send_res")"
    echo "Failed to send message: code=$code msg=$msg_res" >&2
    echo "$send_res" >&2
    exit 1
fi

jq -r '.data.message_id // empty' <<<"$send_res"
