#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


mkdir -p apk-tools
version=3.0.3-r1

wget -P apk-tools https://dl-cdn.alpinelinux.org/alpine/latest-stable/main/x86_64/apk-tools-static-$version.apk

tar -xzf apk-tools/apk-tools-static-$version.apk -C apk-tools

cp apk-tools/sbin/apk.static /sbin/apk

exit
wget -P apk-tools https://dl-cdn.alpinelinux.org/alpine/latest-stable/main/x86_64/apk-tools-$version.apk
tar -xzf apk-tools/apk-tools-$version.apk -C apk-tools

ls apk-tools/etc/apk apk-tools/sbin apk-tools/lib/apk apk-tools/cache

# echo "https://dl-cdn.alpinelinux.org/alpine/latest-stable/main" > /etc/apk/repositories

exit
docker run --rm -it -e NODES_EXCLUDE="[]" -p 5678:5678 n8nio/n8n:stable

# NODES_EXCLUDE: "[\"n8n-nodes-base.executeCommand\", \"n8n-nodes-base.readWriteFile\"]"

exit
# 主 n8n（Editor / API）
EXECUTIONS_MODE=queue        # 必须
N8N_RUNNERS_ENABLED=true     # 开 Runner
N8N_RUNNERS_MODE=external    # 使用外部 Runner

# Runner
N8N_RUNNERS_ENABLED=true
QUEUE_BULL_REDIS_HOST=redis
