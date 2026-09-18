# Title
---
```meta
date: 1970-01-01
authors: []
version: 0.1.0
description: 
```


## 
1. installation
```
projects_path="$PWD/data/projects"
openhands_path="$PWD/data/openhands"

mkdir -p "$projects_path" "$openhands_path"

docker run -it --rm \
  -p 8000:8000 \
  -v "$openhands_path:/home/openhands/.openhands" \
  -v "${projects_path}:/projects" \
  ghcr.io/openhands/agent-canvas:1.20.0
```
