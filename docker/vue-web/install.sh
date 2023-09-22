#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

npm install --global serve @vue/cli # version 3.2.13

vue create vue-web

cd vue-web
