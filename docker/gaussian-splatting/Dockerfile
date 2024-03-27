FROM nvidia/cuda:11.8.0-devel-ubuntu22.04
# FROM nvidia/cuda:11.8.0-base-ubuntu22.04
# FROM nvidia/cuda:12.2.2-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=nointeractive
ENV TZ=Asia/Shanghai
ENV CONDA_HOME=/opt/conda
ENV PATH=/opt/gaussian-splatting/SIBR_viewers/install/bin:$CONDA_HOME/bin:$PATH

RUN mkdir -p /app/3dgs
COPY bin /app/bin

RUN bash /app/bin/install.sh

WORKDIR /app/3dgs
# ENTRYPOINT ["bash", "/app/bin/pipeline.sh"]
