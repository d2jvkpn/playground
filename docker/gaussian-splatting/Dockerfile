FROM nvidia/cuda:11.8.0-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=nointeractive
ENV TZ=Asia/Shanghai
ENV CONDA_HOME=/opt/conda
ENV PATH=/opt/gaussian-splatting/SIBR_viewers/install/bin:$CONDA_HOME/bin:$PATH

RUN apt update && \
  apt -y upgrade && \
  apt install -y git wget zip colmap xvfb imagemagick && \
  apt install -y cmake libglew-dev libassimp-dev libboost-all-dev libgtk-3-dev libopencv-dev \
    libglfw3-dev libavdevice-dev libavcodec-dev libeigen3-dev libxxf86vm-dev libembree-dev && \
  apt clean && \
  rm -rf /var/lib/apt/lists/*

RUN wget -qO ninja.gz \
  https://github.com/ninja-build/ninja/releases/latest/download/ninja-linux.zip && \
  unzip ninja.gz -d /usr/local/bin/ && \
  chmod a+x /usr/local/bin/ninja && \
  rm ninja.gz && \
  ninja --version

# https://docs.conda.io/projects/conda/en/latest/user-guide/install/linux.html
RUN wget -qO miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
  /bin/bash miniconda.sh -b -p /opt/conda && \
  rm miniconda.sh

RUN git clone https://github.com/graphdeco-inria/gaussian-splatting \
    --recursive /opt/gaussian-splatting && \
  cd /opt/gaussian-splatting/SIBR_viewers && \
  cmake -Bbuild -G Ninja . -DCMAKE_BUILD_TYPE=Release && \
  cmake --build build -j24 --target install && \
  rm -rf build/

RUN conda env create --file /opt/gaussian-splatting/environment.yml && \
  conda clean --all --yes

# conda init bash
# exec bash
# conda activate gaussian_splatting

RUN mkdir -p /home/d2jvkpn/3dgs_workspace && \
  ln -s /opt/gaussian-splatting /home/d2jvkpn/3dgs

ADD ./3dgs_pipeline.sh /home/d2jvkpn/

WORKDIR /home/d2jvkpn/3dgs_workspace
# ENTRYPOINT ["bash", "/home/d2jvkpn/3dgs_pipeline.sh"]
