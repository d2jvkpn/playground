#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

# mkdir -p 2024-12-06
# ln -rfs /mnt/vdb1/account/postgres.dump 2024-12-06/
# nohup ossutil64 cp -r 2024-12-06  oss://bucket/postgres_backup/ &

[ $# -lt 2 ] && { >&2 echo '!!!' "no args: files... oss_dir"; exit 1; }
[ -s oss.ini ] && { >&2 echo '!!! no oss.init'; exit 1; }

# files=$@
# oss_dir=oss://bucket/path/to/remote_dir
files="${@:1:$#-1}"
oss_dir="${@: -1}"
oss_dir=${oss_dir%/}

ls -lh "$files"

tag=$(date +%F)
start_at=$(date +%FT%T%:z)

mkdir -p $tag
ln -rfs "$files" $tag/

{
    echo "==> $start_at start: files=$files, oss_dir=$oss_dir/"
    ossutil64 -c oss.ini cp -r $tag $oss_dir/
    echo "<== $(date +%FT%T%:z) end"
} &> ossutil64.${tag}S$(date +%s).log
