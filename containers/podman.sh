#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

sudo apt install podman qemu-utils

podman machine init
# quay.io/podman/machine-os:5.3

pod machine start

pip3 install podman-compose

exit

podman generate systemd --name mycontainer

sudo cp container-mycontainer.service /etc/systemd/system/

sudo systemctl enable container-mycontainer.service
sudo systemctl start container-mycontainer.service


exit
sudo apt insall podman podman-compose buildah
