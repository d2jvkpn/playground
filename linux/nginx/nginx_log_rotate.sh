#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

# 2025-01-03 cat /etc/logrotate.d/nginx

# cron: 0 0 1 * *
# $ crontab -e
# *	minute, 0-59
# *	hour, 0-23
# *	day of month, 1- 31
# *	month, 1-12
# *	day of week, 0-6

# append new line
# $ crontab -l


{
    date +"==> %FT%T%:z start log rotating"

    yesterday=$(date -d 'yesterday' '+%Y-%m-%d')
    pid=$(cat /var/run/nginx.pid)

    for f in $(ls ${HOME}/nginx/logs/*.log); do
        [ -s $f ] || continue
        out=${f%\.log}.${yesterday}.log
        echo "--> saving $out"
        mv $f $out
        pigz $out &
    done

    kill -USR1 $pid

    wait
} >> $(dirname $0)/nginx_log_rotate.$(date +"%Y-%m").log 2>&1
