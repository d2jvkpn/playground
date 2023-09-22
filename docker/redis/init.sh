#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

mkdir -p data/redis

# touch data/redis/redis.log

cat > data/redis.conf <<EOF
requirepass world
logfile /data/redis.log

dir /data
dbfilename dump.rdb
aof-use-rdb-preamble yes
proto-max-bulk-len 32mb
io-threads 4
io-threads-do-reads yes
EOF
