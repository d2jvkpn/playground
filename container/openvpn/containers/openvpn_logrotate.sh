#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

# echo "5 0 1 * * bash /apps/target/openvpn_log.sh" > temp.crontab
# crontab temp.crontab
# rm temp.crontab

# crond -l 0 -f -L /apps/logs/crond.log

if [ ! -s /apps/logs/openvpn.log ]; then
    exit 0
fi

yesterday=$(date -d"yesterday" +%F)

supervisorctl stop openvpn

mv /apps/logs/openvpn.log /apps/logs/openvpn.${yesterday}.log

supervisorctl start openvpn
