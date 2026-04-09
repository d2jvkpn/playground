#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


directory=$1
compose=$(basename $directory)

sudo tar --xattrs --acls --numeric-owner -czpf  "$compose.$(date +%F-%s).tgz" "$directory"

exit
sudo tar --xattrs --acls --numeric-owner -xzpf $compose.tgz -C ./
