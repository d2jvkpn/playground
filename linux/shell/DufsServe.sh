#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

# cargo install dufs@0.34
# config=${_path}/DufsServe.yaml
config=${config:-~/.config/dufs/config.yaml}
[ -f $config ] || { >&2 echo "file not exists: $config"; exit 1; }

target=${1:-${_wd}}

port=$(yq .dufs.port $config)
username=$(yq .dufs.username $config)
password=$(yq .dufs.password $config)
subpath=$(yq .dufs.subpath $config) # ls ${target}${path}

echo "==> dufs: target=$target, port=$port, subpath=$subpath"

dufs --port $port \
  --allow-archive --allow-upload --allow-search \
  --auth $username:$password@$subpath:rw

exit

cat > DufsServe.yaml << EOF
dufs:
  port: 5001
  username: hello
  password: world
  subpath: /
EOF

####
mkdir -p alice bob
echo "Hello, I'm Alice!" > alice/hello.txt
echo "Hello, I'm Bob!" > bob/hello.txt

dufs --bind 127.0.0.1 --port 3000 \
  --allow-upload --allow-search --allow-archive \
  --auth admin:admin@/:r \
  --auth alice:alice@/alice:r \
  --auth bob:bob@/bob:r
