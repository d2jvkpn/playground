#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

# mkdir -p 2024-12-06
# ln -rs /mnt/vdc1/bigdata/{vw_campaign.dump,vw_dashboard.dump,vw.dump,vw_monthly_report.dump} 2024-12-06/
# nohup ossutil64 cp -r 2024-12-06  oss://archive-2024/adb_pg_database_backup/ &

[ $# -eq 0 ] && { >&2 echo '!!!' "no args: filenames"; exit 1; }

args=("$@")
batch_args=$(printf "{%s}" "$(IFS=,; echo "${args[*]}")")

tag=$(date +%F)
source_dir=/path/to/local_dir
oss_dir=oss://bucket/path/to/remote_dir

eval ls -lh $source_dir/$batch_args

echo "==> ${date +%FT%T%:z} start: $batch_args"
mkdir -p $tag
eval ln -rfs $source_dir/$batch_args $tag/

ossutil64 cp -r $tag $oss_dir/ > ossutil64.${tag}-$(date +%s).log
echo "<== ${date +%FT%T%:z} end"
