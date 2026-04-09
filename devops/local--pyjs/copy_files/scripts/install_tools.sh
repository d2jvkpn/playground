#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


####
tag_name=$(
  curl -fsSL https://api.github.com/repos/mikefarah/yq/releases/latest |
  jq -r .tag_name
)

curl -fL https://github.com/mikefarah/yq/releases/download/$tag_name/yq_linux_amd64 \
  -o /usr/local/bin/yq

chmod a+x /usr/local/bin/yq

# apt install -y openvpn wireguard-tools
