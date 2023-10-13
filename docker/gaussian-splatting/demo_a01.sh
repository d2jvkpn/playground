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
# zip -r truck.zip truck && rm -r truck

####
docker run -d --name gaussian-splatting --gpus=all \
  -v $PWD:/data/workspace \
  gaussian-splatting:latest sleep infinity

docker exec -it gaussian-splatting bash

conda init bash
exec bash
conda activate gaussian_splatting
# echo "==> conda: CONDA_DEFAULT_ENV=$CONDA_DEFAULT_ENV, CONDA_PREFIX=$CONDA_PREFIX"

ln -s /opt/gaussian-splatting 3dgs
# unzip truck.zip
# python 3dgs/convert.py -s ./truck --skip_matching
python 3dgs/convert.py -s ./truck --magick_executable /usr/bin/convert --skip_matching --resize

python 3dgs/train.py -s ./truck/ --eval
## pre-trained
# python 3dgs/render.py -m ./output/e9c09354-7/ -s <path to COLMAP dataset>
python 3dgs/render.py -m ./output/e9c09354-7/
python 3dgs/metrics.py -m ./output/e9c09354-7/
