#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

ssh-keygen -R [hostname],[ip_address]
ssh-keyscan -p 22 -H [hostname],[ip_address] >> ~/.ssh/known_hosts
