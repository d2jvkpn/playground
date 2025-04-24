#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


# aliyun: aegis, aliyun, AssistDaemon
# $ systemctl --failed

# path: /usr/local/share/assist-daemon/assist_daemon
systemctl stop AssistDaemon
systemctl disable AssistDaemon

# /usr/local/share/aliyun-assist
systemctl stop aliyun
systemctl disable aliyun

systemctl stop ecs_mq
systemctl disable ecs_mq

# /usr/local/aegis
systemctl stop aegis
# !!! can't disable this service
systemctl disable aegis
mv /etc/systemd/system/aegis.service /etc/systemd/system/aegis.service.bk

for s in pmcd pmie pmie_farm pmlogger pmlogger_farm pmproxy; do
    systemctl stop $s
    systemctl disable $s
done
