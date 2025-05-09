# Title
---
```meta
version: 0.1.0
authors: ["Jane Doe<jane.doe@noreply.local>"]
date: 1970-01-01
```


#### Ch01. 
1. links
- https://hub.docker.com/r/ollama/ollama
- https://docs.openwebui.com/pipelines
- https://github.com/open-webui/pipelines/pkgs/container/pipelines
- https://github.com/open-webui/open-webui/releases
- https://ikasten.io/2024/06/03/getting-started-with-openwebui-pipelines/

2. commands
```bash
#
docker run -d -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama

#
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey \
    | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg

curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list \
    | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' \
    | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

sudo apt-get update

sudo apt-get install -y nvidia-container-toolkit

#
docker run -d --gpus=all -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama

docker run -d --device /dev/kfd --device /dev/dri -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama:rocm

docker pull ollama/ollama:0.5.12
```

3. download models
```
# https://ollama.com/library/deepseek-r1:7b
ollama pull deepseek-r1:7b
ollama pull deepseek-r1:14b

ollama pull deepseek-coder-v2:16b
```

4. request with api
```
####
curl -X POST http://localhost:11434/api/generate -d '{
  "model": "deepseek-r1:7b",
  "prompt": "Why is the sky blue?"
}' > data/response_a01.json

jq -r .response data/response_a01.json | awk '{printf "%s", $0} END{print}'

#####
curl -X POST http://localhost:11434/api/generate -d '{
  "model": "deepseek-r1:14b",
  "prompt": "Why is the sky blue?"
}' > data/response_a02.json

jq -r .response data/response_a02.json | awk '{printf "%s", $0} END{print}'
```

5. pipeline
docker run -d --restart always --name pipelines \
  -p 9099:9099 --add-host=host.docker.internal:host-gateway \
  -v pipelines:/app/pipelines ghcr.io/open-webui/pipelines:main
