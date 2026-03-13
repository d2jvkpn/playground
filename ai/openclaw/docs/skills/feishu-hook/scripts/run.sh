#!/usr/bin/env bash
set -euo pipefail

msg="${*:-}"
if [[ -z "$msg" ]]; then
    echo "Missing message text" >&2
    exit 2
fi
# echo $msg

config=${config:-$HOME/.openclaw/skills/configs/feishu.yaml}

hook_id=$(yq -r '.feishu.hook_id // ""' "$config")

if [[ -z "$hook_id" ]]; then
    echo "Config missing: feishu.hook_id" >&2
    exit 2
fi

body=$(jq -n --arg text "$msg" '{msg_type: "text", content: { text: $text }, timeout: 30}')

send_res=$(curl -X POST \
  -H 'Content-Type: application/json' \
  -d "$body" \
  "https://open.feishu.cn/open-apis/bot/v2/hook/$hook_id" \
)

code="$(jq -r '.code // -1' <<<"$send_res")"
if [[ "$code" != "0" ]]; then
    msg_res="$(jq -r '.msg // "send error"' <<<"$send_res")"
    echo "Failed to send message: code=$code msg=$msg_res" >&2
    echo "$send_res" >&2
    exit 1
fi

jq -r '.msg // empty' <<<"$send_res"
