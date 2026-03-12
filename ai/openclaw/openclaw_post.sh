#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

exit
#### 1. connect
# goto http://127.0.0.1:18789

#### 2. approve the deivce
deviceId=$(docker exec openclaw openclaw devices list --json | jq .pending[0].deviceId)
docker exec openclaw openclaw devices approve $deviceId

#### 3. get token
jq -r .gateway.auth.token data/openclaw/openclaw.json
# goto http://127.0.0.1:18789/overview

#### 4. config
docker exec -it openclaw openclaw onboard
