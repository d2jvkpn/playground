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
nohup docker build . -t local/3dgrut:base &> ../nohup.out &

ssh remote_host docker save local/3dgrut:2025-09-23 |
  pigz > data/local--3dgrut--2025-09-23.tar.gz
```

3. run
```
docker run -d --name 3dgrut \
  --net=host --ipc=host \
  --gpus=all --runtime=nvidia \
  -v $PWD/data:/workspace/data \
  -e DISPLAY \
  local/3dgrut: sleep infinity

docker exec -it 3dgrut bash
apt update && apt install -y colmap xvfb

mkdir -p ./data/nerf_synthetic--ship

nohup xvfb-run colmap automatic_reconstructor \
  --image_path data/nerf_synthetic/ship/train \
  --workspace_path data/nerf_synthetic--ship &> ./data/nerf_synthetic--ship/colmap.log &

nohup xvfb-run python train.py --config-name apps/nerf_synthetic_3dgrt.yaml \
  path=data/nerf_synthetic/ship out_dir=data experiment_name=lego_ship \
  &> data/ship_3dgrt.log &

nohup xvfb-run python train.py --config-name apps/nerf_synthetic_3dgrt.yaml \
  path=data/nerf_synthetic/lego out_dir=data experiment_name=lego_3dgrt \
  &> data/lego_3dgrt.log &

python train.py --config-name apps/nerf_synthetic_3dgrt.yaml \
    path=data/nerf_synthetic/lego with_gui=True test_last=False export_ingp.enabled=False \
    resume=data/lego_3dgrt/lego-1310_084244/ckpt_last.pt
```
