RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates curl gnupg \
  && mkdir -p /etc/apt/keyrings \
  && curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/3bf863cc.pub \
    | gpg --dearmor -o /etc/apt/keyrings/nvidia-cuda.gpg \
  && echo "deb [signed-by=/etc/apt/keyrings/nvidia-cuda.gpg] https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/ /" \
    > /etc/apt/sources.list.d/nvidia-cuda.list \
  && apt-get update


RUN set -eux; \
  apt-get update; \
  apt-get install -y --no-install-recommends ca-certificates curl gnupg; \
  \
  . /etc/os-release; \
  # VERSION_ID 形如 "24.04" -> "2404"
  ubuntu_repo="ubuntu$(echo "$VERSION_ID" | tr -d '.')"; \
  \
  mkdir -p /etc/apt/keyrings; \
  curl -fsSL "https://developer.download.nvidia.com/compute/cuda/repos/${ubuntu_repo}/x86_64/3bf863cc.pub" \
    | gpg --dearmor -o /etc/apt/keyrings/nvidia-cuda.gpg; \
  \
  echo "deb [signed-by=/etc/apt/keyrings/nvidia-cuda.gpg] https://developer.download.nvidia.com/compute/cuda/repos/${ubuntu_repo}/x86_64/ /" \
    > /etc/apt/sources.list.d/nvidia-cuda.list; \
  \
  apt-get update; \
  \
  rm -rf /var/lib/apt/lists/*; \
