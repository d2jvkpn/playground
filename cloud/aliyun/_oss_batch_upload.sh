#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

# mkdir -p 2024-12-06
# ln -rfs /mnt/vdb1/account/postgres.dump 2024-12-06/
# nohup ossutil64 cp -r 2024-12-06  oss://bucket/postgres_backup/ &

[ $# -eq 0 ] && { >&2 echo '!!!' "no args: filenames"; exit 1; }

files=$@

tag=$(date +%F)
oss_dir=oss://bucket/path/to/remote_dir
start_at=$(date +%FT%T%:z)

echo "==> oss_batch_upload.sh: $start_at"
ls -lh "$files"

mkdir -p $tag
ln -rfs "$files" $tag/

{
    echo "==> $start_at start: files=$files, oss_dir=$oss_dir/"
    ossutil64 cp -r $tag $oss_dir/
    echo "<== $(date +%FT%T%:z) end"
} &> ossutil64.${tag}S$(date +%s).log
