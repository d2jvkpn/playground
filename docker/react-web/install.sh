#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
# nvm install --lts
# npm config set registry https://registry.npm.taobao.org
# npm set --location=global prefix ~/Apps
# npm config get registry

npm install --global serve create-react-app yarn

create-react-app react-web
cd react-web

# npm install --save-dev env-cmd
yarn add env-cmd --dev

yarn add sprintf-js antd @aws-sdk/client-s3 ali-oss
yarn upgrade
