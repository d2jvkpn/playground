#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

sudo apt install podman qemu-utils

podman machine init
# quay.io/podman/machine-os:5.3

pod machine start

pip3 install podman-compose
