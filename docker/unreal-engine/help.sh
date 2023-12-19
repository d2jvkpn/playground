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
export UE_App=MyProject WS_Url=ws://192.168.1.1:3032/ws/streamer?project=MyProject UserId=$(id -u)

envsubst > docker-compose.yaml < docker_deploy.yaml
docker-compose up -d

docker stats

docker run --rm --gpus=all nvidia/cuda:11.8.0-base-ubuntu22.04 nvidia-smi

#### quick run
docker run --rm --network=host --gpus all \
  -v $PWD/MyProject:/app/UnrealEngine \
  -v $PWD/logs:/app/UnrealEngine/MyProject/Saved \
  -w /app \
  adamrehn/ue4-runtime:latest \
  ./UnrealEngine/UE/Binaries/Linux/MyProject \
  -AudioMixer -RenderOffScreen \
  -PixelStreamingURL=ws://192.168.1.1:3032/ws/streamer?project=ue
# -PixelStreamingIP=192.168.1.1 -PixelStreamingPort=3032
