#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


npm create nuxt nuxt-app

npm install --production

npm run build
ls dist .output/public
rm dist

# npm run start # nuxt start

# npm install -g serve
npx serve ./dist
