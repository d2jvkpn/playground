#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


#wget -qO /opt/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64

# sed -n 's/.*"tag_name": "\([^"]*\)".*/\1/p' | head -n1
tag_name=$(curl -fsSL https://api.github.com/repos/mikefarah/yq/releases/latest | jq -r .tag_name)

# wget -qO https://github.com/mikefarah/yq/releases/download/$tag_name/yq_linux_amd64
curl -fL https://github.com/mikefarah/yq/releases/download/$tag_name/yq_linux_amd64 -o /opt/bin/yq

chmod a+x /opt/bin/yq
