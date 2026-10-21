#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

config=$1
x=$2
image_tgz=$3
#image_tgz=meiyuan--ka--latest.$(date +%F).tgz

host=$(yq ".$x.host" $config)
work_dir=$(yq ".$x.work_dir" "$config")

date +"==> %FT%T%:z Start"

date +"--> %FT%T%:z rsync image"
rsync -arvP $image_tgz $host:$work_dir

date +"--> %FT%T%:z compose up"
#ssh "$host" 'cd /opt/myapp && bash -s' <<< 'echo hello'

ssh $host "cd $work_dir && bash -s" <<EOF
cd $work_dir && \
docker load -i "$work_dir/$image_tgz" && \
docker compose up -d
EOF

sleep 5

date +"--> %FT%T%:z check stats"
ssh $host "cd $work_dir && docker compose stats --no-stream"

date +"<== %FT%T%:z Exit"
