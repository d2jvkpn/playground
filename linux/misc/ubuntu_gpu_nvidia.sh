#!/usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

####
# OS: Ubuntu 22.04
# GPU: NVIDIA GeForce RTX 3070
# https://linuxconfig.org/how-to-install-the-nvidia-drivers-on-ubuntu-22-04
# https://forums.developer.nvidia.com/t/nvidia-driver-is-not-working-on-ubuntu-22-04/232243
lshw -c display
lshw -c video

sudo ubuntu-drivers devices
sudo ubuntu-drivers autoinstall

sudo reboot now

####
exit

sudo apt install dkms
sudo apt install nvidia-dkms-525
dkms status

sudo apt install nvidia-driver-525
