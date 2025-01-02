#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


if [ $# -eq 0 ]; then
    >&2 echo '!!! hosts are required'
    exit 1
elif [ $# -eq 1 ]; then
    :
else
    for host in "$@"; do
        bash "$0" "$host"
    done
    exit 0
fi


host=$(echo $1 | sed 's#.*//##; s#/.*##')
port=${port:-443}

expiry_date=$(echo |
  openssl s_client -connect $host:$port 2> /dev/null |
  openssl x509 -noout -subject -dates |
  grep "notAfter" |
  cut -d= -f2
)

ans=$(date -u -d "${expiry_date}" +"%Y-%m-%dT%H:%M:%SZ")

echo $host, $ans
