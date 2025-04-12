#!/usr/bin/env bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

ssh Hostname 'HISTFILE=~/.bash_history; history -r; history' > bash.history.$(date +%F-%s).log
