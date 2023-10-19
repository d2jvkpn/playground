FROM nvidia/cuda:11.8.0-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=nointeractive
ENV TZ=Asia/Shanghai
ENV CONDA_HOME=/opt/conda
ENV PATH=/opt/gaussian-splatting/SIBR_viewers/install/bin:$CONDA_HOME/bin:$PATH

ADD ./3dgs_install.sh /home/d2jvkpn/
RUN bash /home/d2jvkpn/3dgs_install.sh

RUN mkdir -p /home/d2jvkpn/3dgs_workspace && \
  ln -s /opt/gaussian-splatting /home/d2jvkpn/3dgs

ADD ./3dgs_pipeline.sh /home/d2jvkpn/

WORKDIR /home/d2jvkpn/3dgs_workspace
# ENTRYPOINT ["bash", "/home/d2jvkpn/3dgs_pipeline.sh"]
