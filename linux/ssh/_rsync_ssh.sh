#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0) # set -x

rsync -e 'ssh -F ssh.conf' -arvP $source_path $target_path
