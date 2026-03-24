#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

exit
#### 1. connect
# goto http://127.0.0.1:18789

#### 2. get token
jq -r .gateway.auth.token data/openclaw/openclaw.json
# goto http://127.0.0.1:18789/overview

#### 4. approve the deivce
request_id=$(docker exec openclaw openclaw devices list --json | jq -r .pending[0].requestId)
docker exec openclaw openclaw devices approve $request_id

#### 4. config
docker exec -it openclaw openclaw onboard

exit
ssh -N -L 18789:127.0.0.1:18789 user@host
