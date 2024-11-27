#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

exit

{
    crontab -l
    echo "0 5 * * * /path/to/command"
} > crontab.tmp

crontab crontab.tmp

rm crontab.tmp

exit

crontab -u username -l
