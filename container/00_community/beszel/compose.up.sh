#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


# docker-compose pull
key=$(yq '.services.beszel-agent.environment.KEY' compose.yaml)

if [[ "$key" == "ssh-ed25519 "* ]]; then
    echo "==> 4. Compose up"
    docker-compose up -d
    exit 0
fi


echo "==> 1. Compose up beszel-server"
docker-compose up -d beszel-server


echo "==> 2. Checking data/beszel/id_ed25519.pub"

n=0
until ls data/beszel/id_ed25519.pub &> /dev/null; do
    sleep 1
    echo -n "."; n=$((n+1)); [ $((n%60)) -eq 0 ] && echo ""
done
echo

key='"'$(cat data/beszel/id_ed25519.pub)'"'
yq -i ".services.beszel-agent.environment.KEY = $key" compose.yaml


echo "==> 3. Compose up beszel-agent"
docker-compose up -d beszel-agent
