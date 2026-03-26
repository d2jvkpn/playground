#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


args=$@
cdp_port="${cdp_port:-9222}"
cdp_bind_addr="${cdp_bind_addr:-172.17.0.1}"
user_data_dir="${user_data_dir:-data/chromium-cdp}"

chromium_pid=""
socat_pid=""
cleanup() {
    if [[ -n "${socat_pid}" ]] && kill -0 "${socat_pid}" 2>/dev/null; then
        kill "${socat_pid}" 2>/dev/null || true
    fi

    if [[ -n "${chromium_pid}" ]] && kill -0 "${chromium_pid}" 2>/dev/null; then
        kill "${chromium_pid}" 2>/dev/null || true
    fi

    wait 2>/dev/null || true
}

trap cleanup EXIT INT TERM

mkdir -p "${user_data_dir}"

####
echo "--> starting chromium"
chromium \
  --no-sandbox \
  --no-first-run \
  --disable-default-apps \
  --disable-sync \
  --no-default-browser-check \
  --disable-background-networking \
  --no-startup-window \
  --remote-debugging-port="${cdp_port}" \
  --proxy-server=http://127.0.0.1:1080 \
  --user-data-dir="${user_data_dir}" \
  $args &

chromium_pid=$!
#  --disable-dev-shm-usage \
#  --remote-debugging-address=0.0.0.0

echo "--> waiting for chromium CDP on 127.0.0.1:${cdp_port}"
for _ in $(seq 1 50); do
    if curl -fsS "http://127.0.0.1:${cdp_port}/json/version" >/dev/null 2>&1; then
        break
    fi
    sleep 0.2
done

if ! curl -fsS "http://127.0.0.1:${cdp_port}/json/version" >/dev/null 2>&1; then
    echo "chromium CDP did not come up on 127.0.0.1:${cdp_port}" >&2
    exit 1
fi

####
echo "--> starting socat ${cdp_bind_addr}:${cdp_port} -> 127.0.0.1:${cdp_port}"
socat \
  "TCP-LISTEN:${cdp_port},bind=${cdp_bind_addr},reuseaddr,fork" \
  "TCP:127.0.0.1:${cdp_port}" &
socat_pid=$!

####
cdpUrl=$(curl http://172.17.0.1:9222/json/version | jq -r '.webSocketDebuggerUrl')

if [ -z "$cdpUrl" ] || [ "$cdpUrl" = "null" ]; then
    echo "failed to get webSocketDebuggerUrl" >&2
    exit 1
fi

####
cat <<EOF
CDP local     : http://127.0.0.1:${cdp_port}
CDP exposed   : http://${cdp_bind_addr}:${cdp_port}
CDP websocket : $cdpUrl

test with:
  curl http://127.0.0.1:${cdp_port}/json/version
  curl http://$cdp_bind_addr:${cdp_port}/json/version
EOF

wait

#### socat
exit
apt-get update

apt-get install -y \
  libnss3 \
  libnss3-tools \
  ca-certificates

update-ca-certificates

socat TCP-LISTEN:9222,fork,reuseaddr,bind=172.17.0.1 TCP:127.0.0.1:9222

#### healthz check
exit
curl http://host.docker.internal:9222/json/version
curl http://127.0.0.1:9222/json/version
curl http://172.17.0.1:9222/json/version

curl -X PUT "http://127.0.0.1:9222/json/new?https://www.baidu.com"


#### docker
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
