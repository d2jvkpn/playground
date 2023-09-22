#### ubuntu
FROM ubuntu:22.04

ARG TZ=${TZ:-Asia/Shanghai}
ARG REGION=${REGION}

ENV TZ=${TZ}

COPY scripts /opt/scripts
RUN chmod a+x /opt/scripts/entrypoint.sh

RUN script=/opt/scripts/${REGION}.debian.sh; \
  if [ -f $script ]; then bash $script; fi

RUN apt update && apt -y upgrade && \
  DEBIAN_FRONTEND=noninteractive apt install -y sudo tzdata pkg-config git wget vim netcat && \
  apt install -y sudo curl python3 python3-pip python3-venv && \
  apt remove && apt autoremove && apt clean && apt autoclean && \
  dpkg -l | awk '/^rc/{print $2}' | xargs -i dpkg -P {} && \
  rm -rf /var/lib/apt/lists/*

RUN useradd -u 1000 -m -s /bin/bash d2jvkpn && \
  usermod -aG sudo d2jvkpn && \
  mkdir -p /etc/sudoers.d && \
  echo "d2jvkpn ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/d2jvkpn

USER d2jvkpn
ENV PATH="/home/d2jvkpn/.local/bin:$PATH"
WORKDIR /home/d2jvkpn

RUN script=/opt/scripts/${REGION}.pip.sh; \
  if [ -f $script ]; then bash $script; fi

RUN pip3 install --upgrade -r /opt/scripts/requirements.txt && \
  rm -rf .cache/pip

# EXPOSE 8080
CMD ["/opt/scripts/entrypoint.sh"]
