#!/usr/bin/env bash
set -eu -o pipefail_wd=$(pwd); _path=$(readlink -f `dirname $0`)

exit

{
    crontab -l
    echo "0 5 * * * /path/to/command"
} > crontab.tmp

crontab crontab.tmp

rm crontab.tmp

exit

crontab -u username -l
