FROM nvidia/cuda:11.8.0-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=nointeractive
ENV TZ=Asia/Shanghai
ENV CONDA_HOME=/opt/conda
ENV PATH=/opt/gaussian-splatting/SIBR_viewers/install/bin:$CONDA_HOME/bin:$PATH

RUN mkdir -p /app/workspace
COPY bin /app/bin

RUN bash /app/bin/3dgs_install.sh

WORKDIR /app/workspace
# ENTRYPOINT ["bash", "/app/bin/3dgs_pipeline.sh"]
