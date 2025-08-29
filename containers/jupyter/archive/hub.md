# Title
---
```meta
date: 1970-01-01
authors: []
version: 0.1.0
```


#### ch01. 
1. generate config
```
mkdir -p configs data/jupyterhub

docker run --rm \
  -v "$(pwd)/configs:/srv/jupyterhub" \
  jupyterhub/jupyterhub:5 jupyterhub --generate-config -f jupyterhub_config.py
```
