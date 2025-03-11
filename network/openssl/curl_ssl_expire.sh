#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


site=$1

output=$(curl -vkI "$site" 2>&1 | grep "expire date:" | sed 's/.*expire date: //')
rfc3339=$(date -d "$output" +"%Y-%m-%dT%H:%M:%S%:z") # -u

t0=$(date +%s)
t1=$(date -d "$output" +%s)
delta=$((t1 - t0))

cat <<EOF
site: $site
expire_date: $output
expire_rfc3339: $rfc3339
expire_left_secs: $delta
EOF
