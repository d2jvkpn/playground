#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


TOKEN=${TOKEN:-$(uuid)}
ALLOWED_ORIGINS=${ALLOWED_ORIGINS:-'["http://localhost:18789","http://127.0.0.1:18789"]'}

openclaw setup
openclaw config set gateway.mode local
openclaw config set gateway.bind lan

auth=$(jq -n --arg TOKEN "$TOKEN" '{mode:"token", token:$TOKEN}')
openclaw config set gateway.auth "$auth" --strict-json

openclaw config set gateway.controlUi.allowedOrigins "$ALLOWED_ORIGINS" --strict-json
