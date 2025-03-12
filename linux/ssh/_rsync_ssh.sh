#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0) # set -x

rsync -e 'ssh -F ssh.conf -o RemoteCommand=none -o RequestTTY=no"' -arvP $source_path $target_path
