#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

# cargo install dufs@0.34
conf=${_path}/dufs-server.yaml
[ -f $conf ] || { echo "file not exists: $conf" >&2; exit 1; }

target=${1:-${_wd}}

port=$(yq .dufs.port $conf)
username=$(yq .dufs.username $conf)
password=$(yq .dufs.password $conf)
subpath=$(yq .dufs.subpath $conf) # ls ${target}${path}

echo "==> dufs: target=$target, port=$port, subpath=$subpath"

dufs --port $port \
  --allow-archive --allow-upload --allow-search \
  --auth $username:$password@$subpath:rw

exit

mkdir -p alice bob
echo "Hello, I'm Alice!" > alice/hello.txt
echo "Hello, I'm Bob!" > bob/hello.txt

dufs --bind 127.0.0.1 --port 3000 \
  --allow-upload --allow-search --allow-archive \
  --auth admin:admin@/:r \
  --auth alice:alice@/alice:r \
  --auth bob:bob@/bob:r
