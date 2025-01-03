#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

npm install --global serve @vue/cli # version 3.2.13

vue create vue-app

cd vue-app
