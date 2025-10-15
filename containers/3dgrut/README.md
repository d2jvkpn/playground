# 3dgrut
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

3. container
```
docker run -d --name 3dgrut --net=host --ipc=host --gpus=all --runtime=nvidia \
  -v $PWD/data:/workspace/data -e DISPLAY \
  local/3dgrut:latest sleep infinity

docker exec -it 3dgrut bash
# apt update && apt install -y colmap xvfb

ls configs/apps/nerf_synthetic_3dgrt.yaml configs/base_gs.yaml
```

4. run
```
mkdir -p data/ship.3dgrt

nohup xvfb-run python train.py --config-name apps/nerf_synthetic_3dgrt.yaml \
  path=data/nerf_synthetic/ship out_dir=data \
  experiment_name=ship.3dgrt &> data/ship.3dgrt/run.log &

mkdir -p data/lego.3dgrt

nohup xvfb-run python train.py --config-name apps/nerf_synthetic_3dgrt.yaml \
  path=data/nerf_synthetic/lego out_dir=data \
  experiment_name=lego.3dgrt &> data/data/lego.3dgrt/run.log &

python train.py --config-name apps/nerf_synthetic_3dgrt.yaml \
    path=data/nerf_synthetic/lego with_gui=True test_last=False export_ingp.enabled=False \
    resume=data/lego.3dgrt/lego-1310_084244/ckpt_last.pt
```
