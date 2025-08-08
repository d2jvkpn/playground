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

2. commands
```
# mkdir -p data/jupyter
mkdir -p data/pip-packages

# -v "${PWD}/data/jupyter":/home/jovyan/work

#docker run -it --rm -p 8888:8888 quay.io/jupyter/datascience-notebook:2025-03-26
docker run -it --rm -p 8888:8888 quay.io/jupyter/base-notebook:2025-08-04
```

3. TODO: root
```
echo "jovyan ALL=(ALL) NOPASSWD:/usr/bin/apt-get" >> /etc/sudoers

echo "jovyan ALL=(ALL:ALL) ALL" > /etc/sudoers.d/jovyan
```

4. shell
```
#python -m venv jupyter.venv
#source jupyter.venv/bin/activate

docker exec -u root -it jupyter bash
apt install update && apt install -y vim
```
