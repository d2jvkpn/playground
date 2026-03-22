#!/bin/bash
set -eu -o pipefail

apt-get update
apt-get install -y ca-certificates gnupg curl jq

mkdir -p /etc/apt/keyrings

curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key |
  gpg --dearmor -o /etc/apt/keyrings/nodejs.gpg

#NODE_MAJOR=24
NODE_MAJOR=$(
  curl -fsSL https://nodejs.org/dist/index.json |
  jq -r '[.[] | select(.lts != false)][0].version' |
  sed 's/^v//' |
  cut -d. -f1
)

echo "deb [signed-by=/etc/apt/keyrings/nodejs.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" \
  | tee /etc/apt/sources.list.d/nodejs.list

apt-get update
apt-get install -y nodejs
#npm install npm@latest
