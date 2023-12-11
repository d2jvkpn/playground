#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

#### colmap
# sudo apt install -y colmap
# colmap gui

# input: ./truck_1/images/*.png
# output: ./truck_1/distorted/database.db, ./truck_1/distorted/sparse/
mkdir -p ./truck_1/distorted
colmap automatic_reconstructor --image_path ./truck_1/images --workspace_path ./truck_1/distorted
# xvfb-run colmap automatic_reconstructor --image_path ./truck_1/images --workspace_path ./truck_1/distorted
ls -d truck_1/input truck_1/distorted/{database.db,sparse}

# zip -r truck_1.zip truck_1

#### 3dgs container
cd truck_1/
docker run -d --name 3dgs --gpus=all -v $PWD:/app/3dgs 3dgs:latest sleep infinity

docker exec -it 3dgs bash

conda init bash
exec bash
conda activate gaussian_splatting

#### convert.py
# input: input/*.png distorted/database.db distorted/sparse/0
# output: images_2/, images_4/, images_8/, sparse/, stereo/, run-colmap-geometric.sh, run-colmap-photometric.sh
ln -s images input
# python ../3dgs/convert.py -s ./ --skip_matching
python ../3dgs/convert.py -s ./ --skip_matching --resize --magick_executable /usr/bin/convert

#### train.py
# input: images/*.png, sparse
# output: output/1efa0583-2/{cameras.json,cfg_args,input.ply,point_cloud}
python ../3dgs/train.py -s ./ --eval

#### render.py
# input: ./output/1efa0583-2/
# output: ./output/1efa0583-2/train
## pre-trained
# python /opt/3dgs/render.py -m ./output/e9c09354-7/ -s <path to COLMAP dataset>
python ../3dgs/render.py -m ./output/1efa0583-2/

#### metrics.py
# input: ./output/1efa0583-2/
# output: ./output/1efa0583-2/results.json
python ../3dgs/metrics.py -m ./output/e9c09354-7/
