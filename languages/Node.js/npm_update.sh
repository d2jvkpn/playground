#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd -P)


npm outdated              # 先查看可更新项
npx npm-check-updates -u  # 更新 package.json 中的版本范围
npm install               # 重新安装
npm test                  # 验证项目正常

#npm update <package-name>
#npm install <package-name>@latest

pnpm outdated                     # 先查看可更新项
npx npm-check-updates -u -p pnpm  # 更新 package.json 中的版本范围
pnpm install                      # 重新安装
pnpm -d ./ test                   # 验证项目正常
