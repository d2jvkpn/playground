#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


token=${OPENCLAW_TOKEN:-$(openssl rand -hex 32)}
allowd_origins=${OPENCLAW_ALLOWED_ORIGINS:-'["http://localhost:18789","http://127.0.0.1:18789"]'}

openclaw setup
openclaw config set gateway.mode local
openclaw config set gateway.bind lan

auth=$(jq -n --arg token "$token" '{mode:"token", token:$token}')
openclaw config set gateway.auth "$auth" --strict-json

openclaw config set gateway.controlUi.allowedOrigins "$allowd_origins" --strict-json
