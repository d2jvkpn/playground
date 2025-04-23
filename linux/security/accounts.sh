#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


usermod -a -G Group User

gpasswd --delete User Group
