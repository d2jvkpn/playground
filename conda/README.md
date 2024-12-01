# Conda
---

#### C01. chapter01
1. links
- https://hub.docker.com/r/continuumio/miniconda3

2. seach all python versions
```bash
conda search python
conda search --full-name python
```

3. list installed python env
```
conda env list
conda info --envs
```

4. create a env with specified python version
```
conda create --name python3.7.9 python=3.7.9
```

5. activate target python env
```
conda activate python3.7.9

python --version
```

6. docker
```bash
docker pull continuumio/miniconda3

docker run -it continuumio/miniconda3 /bin/bash

docker run -i -t -p 8888:8888 continuumio/miniconda3 /bin/bash -c "\
  conda install jupyter -y --quiet && \
  mkdir -p /opt/notebooks && \
  jupyter notebook \
  --notebook-dir=/opt/notebooks --ip='*' --port=8888 \
  --no-browser --allow-root"
```

#### C02. chapter01
