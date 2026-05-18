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

exit
base_url=$(yq .openclaw.base_url ./configs/local.yaml)
token=$(yq .openclaw.token ./configs/local.yaml)

#openclaw:
#  base_url: http://127.0.0.1:8080/api/openclaw
#  token: xxxx

curl -i -X POST $base_url/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $token" \
  -d @examples/v1--responses--text1.json

curl -i -X POST $base_url/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $token" \
  -d @examples/v1--responses--text2.json

curl -i -X POST $base_url/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $token" \
  -d @examples/v1--responses--image1.json

curl -i -X POST $base_url/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $token" \
  -d @examples/v1--responses--image2.json

curl -i -X POST $base_url/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $token" \
  -d @examples/v1--chat--completions.json
