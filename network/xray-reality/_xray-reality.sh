#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit
url="https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip"
echo "Downloading: $url"
mkdir -p /opt/xray
curl -fL --retry 5 --retry-delay 1 -o /opt/Xray-linux-64.zip "$url"
unzip /opt/Xray-linux-64.zip -d /opt/xray
chmod a+x /opt/xray/xray && \
rm -rf /opt/Xray-linux-64.zip

exit
mkdir -p configs

#docker pull ghcr.io/xtls/xray-core:26.2.6
#cat /proc/sys/kernel/random/uuid > configs/server.uuid

{
    docker run --rm ghcr.io/xtls/xray-core:latest uuid | awk '{print "UUID: " $1}'
    docker run --rm ghcr.io/xtls/xray-core:latest x25519
} > configs/xray.yaml

uuid=$(yq .UUID configs/xray.yaml)
private_key=$(yq .PrivateKey configs/xray.yaml)
public_key=$(yq .Password configs/xray.yaml)

ip=167.99.243.148
port=443
short_id=b1

jq \
  --arg uuid "$uuid" \
  --arg short_id "$short_id" \
  --arg private_key "$private_key" '
  .inbounds[0].settings.clients[0].id = $uuid |
  .inbounds[0].streamSettings.privateKey = $private_key |
  .inbounds[0].streamSettings.shortIds[0] = $short_id
  ' examples/reality.server.json > configs/reality.server.json

jq \
  --arg uuid "$uuid" \
  --arg short_id "$short_id" \
  --arg ip "$ip" \
  --argjson port "$port" \
  --arg public_key "$public_key" '
  .outbounds[0].settings.vnext[0].users[0].id = $uuid |
  .outbounds[0].settings.vnext[0].address = $ip |
  .outbounds[0].settings.vnext[0].port = $port |
  .outbounds[0].streamSettings.realitySettings.publicKey = $public_key |
  .outbounds[0].streamSettings.realitySettings.shortId = $short_id
  ' examples/reality.client.json > configs/reality.client.json
