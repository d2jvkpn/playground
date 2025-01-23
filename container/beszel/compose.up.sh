#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


key=$(yq '.services.beszel-agent.environment.KEY' compose.yaml)

if [[ "$key" == "ssh-ed25519 "* ]]; then
    echo "==> compose up"
    docker-compose up -d
    exit 0
fi

echo "==> 1. Compose up beszel"
docker-compose up -d beszel

echo "==> 2. Checking data/beszel/id_ed25519.pub"
until ls data/beszel/id_ed25519.pub; do
    echo -n "."
    sleep 3
done
echo

key=$(cat data/beszel/id_ed25519.pub)
key='"'$key'"'

yq -i ".services.beszel-agent.environment.KEY = $key" compose.yaml

echo "==> 3. Compose up beszel-agent"
docker-compose up -d beszel-agent
