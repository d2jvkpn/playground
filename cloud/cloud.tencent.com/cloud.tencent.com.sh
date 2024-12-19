#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

# tencent cloud: barad_agent YDLive
# path: /etc/systemd/system/cron.service
# path: /etc/cron.d/sgagenttask, /etc/cron.d/yunjing

mkdir -p apps/tencent_cloud
mv /etc/cron.d/sgagenttask /etc/cron.d/yunjing apps/tencent_cloud/
systemctl restart cron

systemctl stop tat_agent
systemctl disable tat_agent
# /usr/local/qcloud/tat_agent/tat_agent
