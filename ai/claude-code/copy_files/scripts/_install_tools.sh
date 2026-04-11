#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


####
bash /opt/scripts/apt_install.sh

####
tag_name=$(
  curl -fsSL https://api.github.com/repos/SagerNet/sing-box/releases/latest |
  jq -r .tag_name
)

filename=sing-box-${tag_name#v}-linux-amd64.tar.gz

curl -fL https://github.com/SagerNet/sing-box/releases/download/$tag_name/$filename -o $filename
tar -xf $filename -C /opt/
ln -s /opt/${filename%.tar.gz}/sing-box /usr/local/bin/

rm -f $filename

####
curl -fL "https://github.com/tsl0922/ttyd/releases/latest/download/ttyd.x86_64" -o /usr/local/bin/ttyd
chmod +x /usr/local/bin/ttyd
