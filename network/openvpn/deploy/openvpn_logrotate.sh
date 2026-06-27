#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

# echo "5 0 1 * * bash /app/target/openvpn_log.sh" > /tmp/crontab
# crontab /tmp/crontab

# crond -l 0 -f -L /app/logs/crond.log

day=${1:-yesterday}

if [ ! -s /app/logs/openvpn.log ]; then
    exit 0
fi

day=$(date -d"$day" +%F)

supervisorctl stop openvpn

mv /app/logs/openvpn.log /app/logs/openvpn.${day}.log

supervisorctl start openvpn
