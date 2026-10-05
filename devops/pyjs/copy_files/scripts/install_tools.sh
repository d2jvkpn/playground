#!/bin/bash
set -eu -o pipefail

. /opt/scripts/arch.sh

####
tag_name=$(
  curl -fsSL https://api.github.com/repos/mikefarah/yq/releases/latest |
  jq -r .tag_name
)

# yq_linux_amd64
curl -fL "https://github.com/mikefarah/yq/releases/download/${tag_name}/yq_linux_${ARCH}" \
  -o /usr/local/bin/yq

chmod a+x /usr/local/bin/yq

# apt install -y openvpn wireguard-tools
