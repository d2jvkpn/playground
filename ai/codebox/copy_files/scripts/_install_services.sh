#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


. /opt/scripts/arch.sh

## sing-box
tag_name=$(
  curl -fsSL https://api.github.com/repos/SagerNet/sing-box/releases/latest |
  jq -r .tag_name
)

#filename=sing-box-${tag_name#v}-linux-amd64.tar.gz
filename=sing-box-${tag_name#v}-linux-${ARCH}.tar.gz

curl -fL https://github.com/SagerNet/sing-box/releases/download/$tag_name/$filename -o $filename
tar -xf $filename -C /opt/
ln -sf /opt/${filename%.tar.gz}/sing-box /usr/local/bin/
rm -f $filename

## tun2proxy
tag_name=$(
  curl -fsSL https://api.github.com/repos/tun2proxy/tun2proxy/releases/latest |
  jq -r .tag_name
)

# https://github.com/tun2proxy/tun2proxy/releases/download/v0.8.4/tun2proxy-x86_64-unknown-linux-gnu.zip
filename=tun2proxy-${ARCH_GNU}-unknown-linux-gnu.zip
curl -fL https://github.com/tun2proxy/tun2proxy/releases/download/${tag_name}/${filename} -o $filename
mkdir -p /opt/tun2proxy
unzip "$filename" -d /opt/tun2proxy
ln -sf /opt/tun2proxy/tun2proxy-bin /usr/local/bin/tun2proxy
rm -f $filename


## ttyd
curl -fL "https://github.com/tsl0922/ttyd/releases/latest/download/ttyd.${RAW_ARCH}" -o /usr/local/bin/ttyd
chmod +x /usr/local/bin/ttyd
