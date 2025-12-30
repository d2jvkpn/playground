#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


apt-get update
apt-get install -y --no-install-recommends ca-certificates curl gnupg

. /etc/os-release
arch="x86_64"

case "$ID" in
ubuntu)
    repo_os="ubuntu$(echo "$VERSION_ID" | tr -d '.')"; \
    ;;
debian)
    # VERSION_ID: "12" / "11" -> debian12 / debian11
    repo_os="debian${VERSION_ID}"
    ;;
*)
    echo "Unsupported distro ID=$ID (VERSION_ID=$VERSION_ID) for NVIDIA CUDA repo auto-setup" >&2
    exit 1
    ;;
esac

mkdir -p /etc/apt/keyrings; \
curl -fsSL "https://developer.download.nvidia.com/compute/cuda/repos/${repo_os}/${arch}/3bf863cc.pub" |
  gpg --dearmor -o /etc/apt/keyrings/nvidia-cuda.gpg

echo "deb [signed-by=/etc/apt/keyrings/nvidia-cuda.gpg] https://developer.download.nvidia.com/compute/cuda/repos/${repo_os}/${arch}/ /" \
  > /etc/apt/sources.list.d/nvidia-cuda.list

apt-get update

rm -rf /var/lib/apt/lists/*

exit
build-essential pkg-config
apt-cache search cudart cuda-toolkit-12-8

exit
dpkg -l | grep cuda
ii  cuda-cccl-12-8                  12.8.90-1                         amd64        CUDA CCCL
ii  cuda-command-line-tools-12-8    12.8.1-1                          amd64        CUDA command-line tools
ii  cuda-compat-12-8                575.57.08-0ubuntu1                amd64        CUDA Compatibility Platform
ii  cuda-compiler-12-8              12.8.1-1                          amd64        CUDA compiler
ii  cuda-crt-12-8                   12.8.93-1                         amd64        CUDA crt
ii  cuda-cudart-12-8                12.8.90-1                         amd64        CUDA Runtime native Libraries
ii  cuda-cudart-dev-12-8            12.8.90-1                         amd64        CUDA Runtime native dev links, headers
ii  cuda-cuobjdump-12-8             12.8.90-1                         amd64        CUDA cuobjdump
ii  cuda-cupti-12-8                 12.8.90-1                         amd64        CUDA profiling tools runtime libs.
ii  cuda-cupti-dev-12-8             12.8.90-1                         amd64        CUDA profiling tools interface.
ii  cuda-cuxxfilt-12-8              12.8.90-1                         amd64        CUDA cuxxfilt
ii  cuda-driver-dev-12-8            12.8.90-1                         amd64        CUDA Driver native dev stub library
ii  cuda-gdb-12-8                   12.8.90-1                         amd64        CUDA-GDB
ii  cuda-libraries-12-8             12.8.1-1                          amd64        CUDA Libraries 12.8 meta-package
ii  cuda-libraries-dev-12-8         12.8.1-1                          amd64        CUDA Libraries 12.8 development meta-package
ii  cuda-minimal-build-12-8         12.8.1-1                          amd64        Minimal CUDA 12.8 toolkit build packages.
ii  cuda-nsight-compute-12-8        12.8.1-1                          amd64        NVIDIA Nsight Compute
ii  cuda-nvcc-12-8                  12.8.93-1                         amd64        CUDA nvcc
ii  cuda-nvdisasm-12-8              12.8.90-1                         amd64        CUDA disassembler
ii  cuda-nvml-dev-12-8              12.8.90-1                         amd64        NVML native dev links, headers
ii  cuda-nvprof-12-8                12.8.90-1                         amd64        CUDA Profiler tools
ii  cuda-nvprune-12-8               12.8.90-1                         amd64        CUDA nvprune
ii  cuda-nvrtc-12-8                 12.8.93-1                         amd64        NVRTC native runtime libraries
ii  cuda-nvrtc-dev-12-8             12.8.93-1                         amd64        NVRTC native dev links, headers
ii  cuda-nvtx-12-8                  12.8.90-1                         amd64        NVIDIA Tools Extension
ii  cuda-nvvm-12-8                  12.8.93-1                         amd64        CUDA nvvm
ii  cuda-opencl-12-8                12.8.90-1                         amd64        CUDA OpenCL native Libraries
ii  cuda-opencl-dev-12-8            12.8.90-1                         amd64        CUDA OpenCL native dev links, headers
ii  cuda-profiler-api-12-8          12.8.90-1                         amd64        CUDA Profiler API
ii  cuda-sanitizer-12-8             12.8.93-1                         amd64        CUDA Sanitizer
ii  cuda-toolkit-12-8-config-common 12.8.90-1                         all          Common config package for CUDA Toolkit 12.8.
ii  cuda-toolkit-12-config-common   12.9.79-1                         all          Common config package for CUDA Toolkit 12.
ii  cuda-toolkit-config-common      13.1.80-1                         all          Common config package for CUDA Toolkit.
hi  libcudnn9-cuda-12               9.8.0.87-1                        amd64        cuDNN runtime libraries for CUDA 12.8
ii  libcudnn9-dev-cuda-12           9.8.0.87-1                        amd64        cuDNN development headers and symlinks for CUDA 12.8
hi  libnccl-dev                     2.25.1-1+cuda12.8                 amd64        NVIDIA Collective Communication Library (NCCL) Development Files
hi  libnccl2                        2.25.1-1+cuda12.8                 amd64        NVIDIA Collective Communication Library (NCCL) Runtime
