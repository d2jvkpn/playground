# Title
---
```meta
date: 1970-01-01
authors: []
version: 0.1.0
```


#### ch01. 
1. docs
- https://github.com/nv-tlabs/3dgrut
- https://www.youtube.com/watch?v=FI5JluMoBDE

2. build
```
mkdir -p data
git clone https://github.com/nv-tlabs/3dgrut data/3dgrut.git

cd data/3dgrut.git
tag=$(date +%F)
nohup docker build . -t local/3dgrut:$tag &> ../nohup.out &

ssh remote_host docker save local/3dgrut:2025-09-23 |
  pigz > data/local--3dgrut--2025-09-23.tar.gz
```

3. run
```
docker run -v --rm -it \
  --gpus=all --net=host --ipc=host \
  -v $PWD/data:/workspace/data \
  --runtime=nvidia -e DISPLAY local/3dgrut:2025-09-23

apt install -y colmap xvfb

mkdir -p ./data/nerf_synthetic--lego

#colmap automatic_reconstructor \
#  --image_path data/nerf_synthetic/lego/train \
#  --workspace_path ./data/nerf_synthetic--lego

xvfb-run colmap automatic_reconstructor \
  --image_path data/nerf_synthetic/lego/train \
  --workspace_path data/nerf_synthetic/lego

python train.py --config-name apps/colmap_3dgrt.yaml \
  path=data/nerf_synthetic/lego \
  out_dir=data/nerf_synthetic/lego \
  experiment_name=nerf_synthetic--lego \
  dataset.downsample_factor=2 \
  optimizer.type=selective_adam
```
