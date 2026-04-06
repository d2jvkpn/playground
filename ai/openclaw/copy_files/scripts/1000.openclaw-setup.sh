#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


OPENCLAW_HOME=${OPENCLAW_HOEM:-$HOME/.openclaw}
NODE_COMPILE_CACHE=${NODE_COMPILE_CACHE:-$HOME/.openclaw/compile-cache}

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

auth=$(jq -n --arg token "$(openssl rand -hex 32)" '{mode:"token", token:$token}')
openclaw config set gateway.auth "$auth" --strict-json

allowed_origins='["http://localhost:18789","http://127.0.0.1:18789"]'
openclaw config set gateway.controlUi.allowedOrigins "$allowed_origins" --strict-json
