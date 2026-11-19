#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd -P)


mkdir -p data/vikunja/db data/vikunja/files
sudo chown -R 1000:1000 data/vikunja/db data/vikunja/files

exit
VIKUNJA_SECRET=$(openssl rand -hex 32)

docker compose up -d
docker compose logs -f vikunja

exit
docker exec vikunja /app/vikunja/vikunja user list

# 创建用户（交互式输入密码）
docker exec -it vikunja /app/vikunja/vikunja \
  user create -u tester -e tester@example.com

# 禁用某个用户
docker exec vikunja /app/vikunja/vikunja \
  user change-status 2 --disable

# 重置用户密码
docker exec -it vikunja /app/vikunja/vikunja \
  user reset-password 2 --direct
