#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname $0`)

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

#### set max power
exit
nvidia-smi -q -d POWER | grep "Max Power Limit"

# 开启持久模式
sudo nvidia-smi -pm 1

# 把功耗上限调低 10~20%
sudo nvidia-smi -pl 200

#### recover to default
# 恢复默认功耗上限
sudo nvidia-smi -pl DEFAULT

# 恢复应用时钟（显存 + 核心）
sudo nvidia-smi -rac

# 0=自动，1=手动
nvidia-settings -a [gpu:0]/GPUFanControlState=0

nvidia-smi -q -d POWER,CLOCK
