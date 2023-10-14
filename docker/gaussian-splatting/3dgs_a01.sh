#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

####
ls -d truck/input
mkdir -p ./truck/distorted

# sudo apt install -y colmap
# colmap gui
colmap automatic_reconstructor --image_path ./truck/input --workspace_path ./truck/distorted
ls -d truck/input truck/distorted/{database.db,sparse}

####
docker run -d --name 3dgs --gpus=all --user $(id -u) \
  -v $PWD/truck:/home/d2jvkpn/3dgs 3dgs:latest sleep infinity

docker exec -it 3dgs bash

#### . /home/d2jvkpn/3dgs_conda.sh
. ../3dgs_conda.sh

# python 3dgs/convert.py -s ./truck --skip_matching
python /opt/3dgs/convert.py -s ./ --skip_matching --resize --magick_executable /usr/bin/convert

python /opt/3dgs/train.py -s ./ --eval

## pre-trained
# python /opt/3dgs/render.py -m ./output/e9c09354-7/ -s <path to COLMAP dataset>
python /opt/3dgs/render.py -m ./output/e9c09354-7/

python /opt/3dgs/metrics.py -m ./output/e9c09354-7/
