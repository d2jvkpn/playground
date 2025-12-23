# Title
---
```meta
date: 2025-08-25
authors: []
version: 0.1.0
```


#### ch01. container
1. build an image
```bash
docker build -f Containerfile --no-cache \
  -t local/jupyter:pytorch2.8.0-cuda12.9-cudnn9-runtime \
  ./
```

2. run a container(can't detect cuda with compose.jupyter.yaml)
```bash
mkdir -p configs data logs

docker run -d --restart=always --gpus=all \
  --name=jupyter --hostname=jupyter \
  -p 8888:8888 \
  -v $(pwd):/root/workspace \
  --env-file=configs/container.env \
  local/jupyter:pytorch2.8.0-cuda12.9-cudnn9-runtime
```

#### ch02. config
1. install torch+cuda
```
pip install torch==2.7.1+cu126 --index-url https://download.pytorch.org/whl/cu126
# torch==2.5.1+cu124 torchvision==0.20.1+cu124 torchaudio==2.5.1+cu124 --index-url https://download.pytorch.org/whl/cu124
```

2. install extensions
```bash
uv pip install jupyterlab-execute-time

uv pip install jupyter-resource-usage
# config to show cpu, ~/jupyter/jupyter_lab_config.py
#
#```bash
#[ -s ~/jupyter/jupyter_lab_config.py ] || jupyter-lab --generate-config
#```
#
#```python
#c = get_config()
#c.ResourceUseDisplay.track_cpu_percent = True
#```

uv pip install jupyterlab-nvdashboard
```

3. install bash kernel
```
uv pip install bash_kernel
python -m bash_kernel.install
```

4. run jupyter in local
```bash
. .venv/bin/activate
. configs/local.env

export JUPYTER_TOKEN=$JUPYTER_TOKEN

jupyter lab --no-browser --allow-root --ip=0.0.0.0 --port=8888
```

5. ?? env
```
  GRANT_SUDO: yes
  JUPYTER_ALLOW_ROOT: "1"
  JUPYTER_ENABLE_LAB: yes
  NB_UID: ${UID}
  NB_GID: ${GID}
  CHOWN_HOME: yes
```
