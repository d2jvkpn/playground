#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


python3 openclaw_test.py --prompt "你是谁?"

python3 openclaw_test.py --prompt "这副图里是什么" \
  --image_url "https://pixnio.com/free-images/2024/09/12/2024-09-12-09-12-03-1152x768.jpg"

python3 openclaw_test.py --prompt "这副图里是什么" --file_path "data/cat_and_otter.png"

exit
openclaw config get gateway.http.endpoints.responses.images.allowUrl
openclaw config get gateway.http.endpoints.responses.images.urlAllowlist

openclaw config set gateway.http.endpoints.responses.images.allowUrl true

openclaw config set gateway.http.endpoints.responses.images.urlAllowlist '["your-cdn.example.com","*.your-oss.com"]'
