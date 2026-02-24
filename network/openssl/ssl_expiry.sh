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

if [[ "$host" == *":"* ]]; then
    addr=$host
else
    addr=$host:${port:-443}
fi

# openssl x509 -noout -subject -dates
# date -u -d "${expiry_date}" +"%Y-%m-%dT%H:%M:%SZ"
output=$(
  echo |
  openssl s_client -connect $addr 2> /dev/null |
  openssl x509 --noout --enddate 2>&1 |
  head -n 1 || true
)

if [[ "${output}" != "notAfter="* ]]; then
    echo "error: $output"
    exit 0
fi

date1=$(echo $output | cut -d= -f2 | xargs -i date -u -d "{}" +"%Y-%m-%dT%H:%M:%SZ")
date2=$(echo $output | cut -d= -f2 | xargs -i date -d "{}" +"%Y-%m-%dT%H:%M:%S%:z")

echo $host, $date1, $date2

exit

# Check if the cer will be expired in 30 days
openssl x509 -checkend 2592000 -noout -in domain.cer
# exit 0: Certificate will not expire
# exit 1: Certificate will expire

if openssl x509 -checkend 2592000 -noout -in domain.cer; then
    echo "OK: cert valid for at least 30 days"
else
    echo "ALERT: cert expires within 30 days (or already expired)"
fi
