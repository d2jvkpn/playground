#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

# echo "5 0 1 * * bash /apps/target/openvpn_log.sh" > /tmp/crontab
# crontab /tmp/crontab

# crond -l 0 -f -L /apps/logs/crond.log

day=${1:-yesterday}

if [ ! -s /apps/logs/openvpn.log ]; then
    exit 0
fi

day=$(date -d"$day" +%F)

supervisorctl stop openvpn

mv /apps/logs/openvpn.log /apps/logs/openvpn.${day}.log

supervisorctl start openvpn
