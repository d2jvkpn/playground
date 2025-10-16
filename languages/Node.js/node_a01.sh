#!/usr/bin/env bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


npm install --global typescript@5.0.2

npm install --save-dev @types/node
npm uninstall @types/node
npm fund

npm update

exit
npm outdated
npx npm-check-updates
npx npm-check-updates -u
npm install

exit
rm -rf node_modules package-lock.json
npm install

exit
npm ls inflight
npm ls set-value
npm ls glob
npm ls rimraf

# or
npx npm-why inflight
npx npm-why set-value
npx npm-why glob
npx npm-why rimraf

exit
npm dedupe
npm audit
