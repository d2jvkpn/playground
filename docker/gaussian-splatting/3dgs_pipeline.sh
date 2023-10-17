#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

#### 1. colmap
## input: images/*.png
## output: distorted/database.db, distorted/sparse/0

ls images/* > /dev/null
mkdir -p distorted

if [ ! -d distorted/sparse/0 ]; then
    {
        date +'==> %FT%T%:z colmap start'
        xvfb-run colmap automatic_reconstructor --image_path ./images --workspace_path ./distorted
        date +'==> %FT%T%:z colmap end'
    } &> colmap.log
fi

# conda init bash
# exec bash
# conda activate gaussian_splatting

#### 2. convert.py
## input: input/*.png distorted/database.db distorted/sparse/0
## output: images_2/, images_4/, images_8/, sparse/, stereo/, run-colmap-geometric.sh, run-colmap-photometric.sh

ln -s images input

{
    date +'==> %FT%T%:z convert.py start'

    conda run -n gaussian_splatting python3 /opt/gaussian-splatting/convert.py \
      -s ./ --skip_matching --resize --magick_executable /usr/bin/convert

    date +'==> %FT%T%:z convert.py end'
} &> convert.log

rm -f input

#### 3. train.py
## input: images/*.png, sparse
## output: output/1efa0583-2/{cameras.json,cfg_args,input.ply,point_cloud}

rm -rf output

{
    date +'==> %FT%T%:z train.py start'
    conda run -n gaussian_splatting python3 /opt/gaussian-splatting/train.py -s ./ --eval
    date +'==> %FT%T%:z train.py end'
} &> train.log

#### 4. render.py
## input: ./output/XXXX/
## output: ./output/XXXX/train

result_dir=$(ls -d output/*/)

{
    date +'==> %FT%T%:z render.py start'
    conda run -n gaussian_splatting python3 /opt/gaussian-splatting/render.py -m $result_dir
    date +'==> %FT%T%:z render.py end'
} &> render.log

#### 5. metrics.py
## input: ./output/XXXX/
## output: ./output/XXXX/results.json

{
    date +'==> %FT%T%:z metrics.py start'
    conda run -n gaussian_splatting python /opt/gaussian-splatting/metrics.py -m $result_dir
    date +'==> %FT%T%:z metrics.py end'
} &> metrics.log
