#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


OPENCLAW_HOME=${OPENCLAW_HOEM:-$HOME/.openclaw}
NODE_COMPILE_CACHE=${NODE_COMPILE_CACHE:-$HOME/.cache/node-compile-cache}

####
mkdir -p $NODE_COMPILE_CACHE

if [ -f  "$OPENCLAW_HOME/openclaw.json" ]; then
    exit 0
fi

####
printf '[%s] running: %s\n' "$(date +%FT%T%:z)" "$0"

openclaw setup
openclaw config set gateway.mode local
openclaw config set gateway.bind lan

# options: main | per-peer | per-account-channel-peer
openclaw config set session.dmScope per-channel-peer

openclaw config set update.auto.enabled false

auth=$(jq -n --arg token "$(openssl rand -hex 32)" '{mode:"token", token:$token}')
openclaw config set gateway.auth "$auth" --strict-json

####
OPENCLAW_ALLOW_ORIGINS=${OPENCLAW_ALLOW_ORIGINS:-""}
IFS=',' read -ra origin_array <<< "$OPENCLAW_ALLOW_ORIGINS"

allowed_origins='["http://localhost:18789","http://127.0.0.1:18789","http://127.0.0.1:18790"]'

for origin in "${origin_array[@]}"; do
  allowed_origins=$(echo "$allowed_origins" | jq -c --arg origin "$origin" '
    if index($origin) then . else . + [$origin] end
  ')
done

openclaw config set gateway.controlUi.allowedOrigins "$allowed_origins" --strict-json
