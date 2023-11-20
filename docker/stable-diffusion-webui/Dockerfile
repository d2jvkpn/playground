FROM ubuntu:22.04

ARG SD_Version=${SD_Version:-1.6.0}
ENV SD_Version=$SD_Version
ENV DEBIAN_FRONTEND=nointeractive

RUN apt update && \
  apt -y upgrade && \
  apt install -y git wget tzdata pkg-config python3 python3-pip python3-venv \
    libgl1 libglib2.0-0 libsm6 libxrender1 libxext6 && \
  apt remove && \
  apt autoremove && \
  apt clean && \
  apt autoclean && \
  dpkg -l | awk '/^rc/{print $2}' | xargs -i dpkg -P {} && \
  rm -rf /var/lib/apt/lists/*

RUN  mkdir -p /app/bin

RUN sdw=stable-diffusion-webui; \
  link=https://github.com/AUTOMATIC1111/${sdw}/archive/refs/tags/v${SD_Version}.tar.gz; \
  wget -O ${sdw}-${SD_Version}.tar.gz $link && \
  tar -xf ${sdw}-${SD_Version}.tar.gz && \
  rm ${sdw}-${SD_Version}.tar.gz && \
  mv ${sdw}-${SD_Version} /app/sd-webui

WORKDIR /app/sd-webui

# git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui ./
RUN python3 -m venv venv/ && \
  pip3 install -r requirements_versions.txt && \
  pip3 install -U xformers && \
  pip3 install --upgrade git+https://github.com/huggingface/diffusers.git && \
  rm -rf /root/.cache/pip

RUN mkdir -p extensions && \
  git clone https://github.com/lllyasviel/ControlNet extensions/ControlNet && \
  git clone https://github.com/Mikubill/sd-webui-controlnet extensions/sd-webui-controlnet && \
  # git clone https://github.com/Uminosachi/sd-webui-inpaint-anything extensions/sd-webui-inpaint-anything && \
  mkdir -p repositories && \
  git clone https://github.com/salesforce/BLIP.git repositories/BLIP && \
  git clone https://github.com/sczhou/CodeFormer.git repositories/CodeFormer && \
  git clone https://github.com/crowsonkb/k-diffusion.git repositories/k-diffusion && \
  git clone https://github.com/Stability-AI/stablediffusion.git repositories/stable-diffusion-stability-ai && \
  git clone https://github.com/CompVis/taming-transformers.git repositories/taming-transformers && \
  git clone https://github.com/Stability-AI/generative-models.git repositories/generative-models && \
  rm -rf /root/.cache/pip

ADD entrypoint.sh /app/bin/entrypoint.sh
RUN chmod a+x /app/bin/entrypoint.sh

EXPOSE 7860
CMD ["/app/bin/entrypoint.sh", "--xformers", "--listen", "--api", "--port=7860"]
