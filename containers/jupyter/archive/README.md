# Title
---
```meta
date: 1970-01-01
authors: []
version: 0.1.0
```


#### ch01. 
1. docs
- https://hub.docker.com/r/jupyter/datascience-notebook/
- https://jupyter-docker-stacks.readthedocs.io/en/latest/index.html
- https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html
- https://github.com/iot-salzburg/gpu-jupyter
- https://hub.docker.com/r/cschranz/gpu-jupyter/tags

2. images
- quay.io/jupyter/datascience-notebook:2025-03-26
- quay.io/jupyter/base-notebook:2025-08-04
- quay.io/jupyter/pytorch-notebook:2025-08-04
- nvidia/cuda:12.6.3-cudnn-runtime-ubuntu24.04
- cschranz/gpu-jupyter:v1.9_cuda-12.6_ubuntu-24.04

3. commands
```
# mkdir -p data/jupyter
mkdir -p data/work/data/pip_packages data/work/data/pip_cache

sudo apt install nvidia-driver-575

# -v "${PWD}/data/jupyter":/home/jovyan/work

docker run -it --rm -p 8888:8888 $image
```

4. TODO: root
```
echo "jovyan ALL=(ALL) NOPASSWD:/usr/bin/apt-get" >> /etc/sudoers

echo "jovyan ALL=(ALL:ALL) ALL" > /etc/sudoers.d/jovyan
```

5. shell
```
#python -m venv jupyter.venv
#source jupyter.venv/bin/activate

docker exec -u root -it jupyter bash
apt install update && apt install -y vim

pip install --no-clean -r pip.txt
pip install --cache-dir=data/pip_cache/ -r pip.txt
```

6. gpu
```
docker run -d --restart=always --gpus=all \
    --name=jupyter --user root -p 8888:8888 \
    -v $(pwd)/pip.conf:/home/jovyan/.config/pip/pip.conf \
    -v $(pwd)/data/work:/home/jovyan/work \
    -v $(pwd)/bash_aliases.sh:/home/jovyan/.bash_aliases \
    --env-file=configs/container.env \
    --workdir=/home/jovyan/work \
    cschranz/gpu-jupyter:v1.9_cuda-12.6_ubuntu-24.04
```
