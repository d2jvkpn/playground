#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

#### host driver
sudo ubuntu-drivers devices
# ubuntu-drivers autoinstall
# sudo apt install nvidia-driver-525
# nvidia-smi

#### docker nvidia
distribution=$(. /etc/os-release; echo $ID$VERSION_ID)

curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey |
  sudo gpg --dearmor -o /etc/apt/keyrings/nvidia-container-toolkit.gpg

curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list |
  sed 's#deb https://#deb [signed-by=/etc/apt/keyrings/nvidia-container-toolkit.gpg] https://#g' |
  sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

sudo apt update
sudo apt install nvidia-container-toolkit nvidia-container-runtime

systemctl restart docker

#### docker compose
export UE_App=MyProject WS_Url=ws://192.168.0.1:3032/ws/streamer?project=MyProject

envsubst > docker-compose.yaml < deploy.yaml
docker-compose up -d

docker stats

docker run --rm --gpus=all nvidia/cuda:11.8.0-base-ubuntu22.04 nvidia-smi

#### quick run
docker run --rm --network=host --gpus all \
  -v /path/to/peoject:/opt/unreal_engine \
  adamrehn/ue4-runtime:latest \
  /opt/unreal_engine/UE/Binaries/Linux/UE \
  -AudioMixer -RenderOffScreen \
  -PixelStreamingIP=192.168.0.1 -PixelStreamingPort=3032

docker run --rm --network=host --gpus all \
  -v /path/to/peoject:/opt/unreal_engine \
  adamrehn/ue4-runtime:latest \
  /opt/unreal_engine/UE/Binaries/Linux/UE \
  -AudioMixer -RenderOffScreen \
  -PixelStreamingURL=ws://192.168.0.1:3032/ws/streamer?project=ue
