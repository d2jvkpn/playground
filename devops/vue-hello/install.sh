#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


# npm init vite@latest # interactive
npm init vite@latest vue-hello -- --template=vue-ts

cd vue-hello

npm install
npm run dev

exit
npm update
npm fund

exit
npm install --global yarn
yarn --version

exit
npm install -D esbuild@0.24.0

npm install vite-tsconfig-paths

#npm install --save-dev @types/node
