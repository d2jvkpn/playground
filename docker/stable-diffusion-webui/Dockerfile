FROM ubuntu:22.04

ARG SD_Version=${SD_Version:-1.6.0}

RUN apt update && \
  apt -y upgrade && \
  DEBIAN_FRONTEND=noninteractive apt install -y git wget tzdata pkg-config \
    python3 python3-pip python3-venv \
    libgl1 libglib2.0-0 libsm6 libxrender1 libxext6 && \
  apt remove && \
  apt autoremove && \
  apt clean && \
  apt autoclean && \
  dpkg -l | awk '/^rc/{print $2}' | xargs -i dpkg -P {} && \
  rm -rf /var/lib/apt/lists/*

RUN useradd -u 1000 -m -s /bin/bash hello
USER hello:hello
ENV PATH="/home/hello/.local/bin:$PATH"

WORKDIR /home/hello
RUN sdw=stable-diffusion-webui && \
  wget -O ${sdw}-${SD_Version}.tar.gz \
  https://github.com/AUTOMATIC1111/${sdw}/archive/refs/tags/v${SD_Version}.tar.gz && \
  tar -xf ${sdw}-${SD_Version}.tar.gz && \
  rm ${sdw}-${SD_Version}.tar.gz && \
  mv ${sdw}-${SD_Version} /home/hello/sd-webui

WORKDIR /home/hello/sd-webui

# git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui ./
RUN python3 -m venv venv/ && \
  pip3 install -r requirements_versions.txt && \
  pip3 install -U xformers && \
  pip3 install --upgrade git+https://github.com/huggingface/diffusers.git && \
  rm -rf /home/hello/.cache/pip
# xformers

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
  rm -rf /home/hello/.cache/pip

ADD entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

EXPOSE 7860
CMD ["/entrypoint.sh", "--xformers", "--listen", "--api", "--port=7860"]
