#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit
chromium \
  --no-sandbox \
  --no-first-run \
  --disable-default-apps \
  --disable-sync \
  --no-default-browser-check \
  --disable-background-networking \
  --no-startup-window \
  --remote-debugging-port=9222 \
  --remote-debugging-address=0.0.0.0 \
  --proxy-server=http://127.0.0.1:1080 \
  --user-data-dir=/tmp/openclaw-chromium \
  --headless

# --disable-dev-shm-usage
# not working:  --remote-debugging-address=0.0.0.0

exit
socat TCP-LISTEN:9222,fork,reuseaddr,bind=172.17.0.1 TCP:127.0.0.1:9222

exit
apt-get update

apt-get install -y \
  libnss3 \
  libnss3-tools \
  ca-certificates

update-ca-certificates

exit
# healthz check
curl http://host.docker.internal:9222/json/version
curl http://127.0.0.1:9222/json/version
curl http://172.17.0.1:9222/json/version

curl -X PUT "http://127.0.0.1:9222/json/new?https://www.baidu.com"

exit
docker run -d \
  --name openclaw-cdp \
  -p 9222:9222 \
  ghcr.io/browserless/chromium \
  chromium \
    --headless=new \
    --no-sandbox \
    --remote-debugging-address=0.0.0.0 \
    --remote-debugging-port=9222 \
    --user-data-dir=/tmp/chromium
