#!/usr/bin/env bash
set -euo pipefail

container="odoo"
db="odoo_prod"
bk_dir=/mnt/share/odoo
bk_file="${bk_dir}/${container}--${db}.$(date +%Y-%m-%d-%s).bk.zip"

##
mkdir -p /tmp/odoo "$bk_dir"

# 防止重复执行
exec 9>/tmp/odoo/${container}--${db}.lock
if ! flock -n 9; then
    echo "Backup already running: ${container}/${db}" >&2
    exit 0
fi

##
# 备份数据库及 filestore
docker exec "$container" odoo db dump "$db" "$bk_file"

# 验证 ZIP
unzip -tq "${bk_file}"

echo "Backup completed: $bk_file"

##
# 清理超过14天的备份
find "$bk_dir" \
  -name "${container}--${db}.*.bk.zip" \
  -type f -mtime +13 -delete
