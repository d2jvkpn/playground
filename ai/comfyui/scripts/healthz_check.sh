#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


curl -fsS http://127.0.0.1:8188/queue | python3 -c 'import sys,json; json.load(sys.stdin); print("OK")'


python3 - <<'PY'
import asyncio, websockets, json
async def main():
    uri="ws://127.0.0.1:8188/ws"
    async with websockets.connect(uri, open_timeout=3, close_timeout=3) as ws:
        # if we can connect, that's already a good sign
        print("OK")
asyncio.run(main())
PY


exit
curl -sv http://127.0.0.1:8188/ 2>&1 | head -n 30
