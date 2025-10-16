#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


npm install --global serve @vue/cli

vue create vue-app --default --packageManager=npm

cd vue-app

npm install
npm run dev

exit

#### update
npm outdated
npx npm-check-updates
npx npm-check-updates -u
npm install
