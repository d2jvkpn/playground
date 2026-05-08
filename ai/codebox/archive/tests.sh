#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


####
mkdir -p configs data/workspace data/npm

cat > configs/bash_aliases <<'EOF'
export PATH="$HOME/.local/npm/bin:$PATH"
EOF

cat > configs/npmrc <<'EOF'
prefix=/home/node/.local/npm
registry=https://registry.npmmirror.com
EOF

# .npmrc: prefix=/home/node/.local/npm
# npm config set prefix ~/.local/npm
# export NPM_CONFIG_USERCONFIG=/path/to/custom.npmrc

# npm config set registry https://registry.npmmirror.com

####
docker run --rm -it \
  --network=host \
  --env https_proxy=http://127.0.0.1:1080 \
  -v $(pwd)/container/bash_aliases:/home/node/.bash_aliases \
  -v $(pwd)/container/npmrc:/home/node/.npmrc \
  -v $(pwd)/data/local:/home/node/.local \
  -v $(pwd)/data/workspace:/home/workspace \
  --entrypoint="" \
  --user=node:node \
  --workdir=/home/workspace \
  node:24-trixie bash

exit
npm install -g opencode-ai@latest
