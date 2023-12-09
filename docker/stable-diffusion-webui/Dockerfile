FROM ubuntu:22.04

ARG SD_Version=${SD_Version:-1.6.0}
ENV SD_Version=$SD_Version
ENV DEBIAN_FRONTEND=nointeractive

RUN apt update && \
  apt -y upgrade && \
  apt install -y --no-install-recommends \
    git wget tzdata pkg-config python3 python3-pip python3-venv \
    libgl1 libglib2.0-0 libsm6 libxrender1 libxext6 && \
  apt remove && \
  apt autoremove && \
  apt clean && \
  apt autoclean && \
  dpkg -l | awk '/^rc/{print $2}' | xargs -i dpkg -P {} && \
  rm -rf /var/lib/apt/lists/*

RUN mkdir -p /app/bin
COPY bin /app/bin
RUN chmod a+x /app/bin/*.sh

WORKDIR /app

RUN sdw=stable-diffusion-webui; \
  link=https://github.com/AUTOMATIC1111/${sdw}/archive/refs/tags/v${SD_Version}.tar.gz; \
  wget -O ${sdw}-${SD_Version}.tar.gz $link && \
  tar -xf ${sdw}-${SD_Version}.tar.gz && \
  mv ${sdw}-${SD_Version} sd-webui

WORKDIR /app/sd-webui
RUN bash /app/bin/install.sh

EXPOSE 7860
CMD ["/app/bin/entrypoint.sh", "--xformers", "--listen", "--api", "--port=7860"]
