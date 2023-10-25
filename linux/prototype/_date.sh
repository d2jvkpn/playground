#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

#### rfc3339
date --rfc-3339=seconds | sed "s/ /T/"

date +'%FT%T.%N%:z'
date +'%FT%H-%M-%S-%N'
date +'%FT%s'
date +'%FT%H-%M-%ST%s'
date -u +'%FT%H-%M-%ST%s'

hostnamectl status
timedatectl show
timedatectl set-hostname Asia/Shanghai

TZ='America/Los_Angeles' date +'%w %W %Z %b'

#### convert
git log -1 --format="%at" | xargs -I{} date -d @{} +'%FT%T%:z'
