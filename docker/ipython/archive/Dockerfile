FROM ubuntu:22.04

ARG TZ=${TZ:-Asia/Shanghai}
ARG REGION=${REGION}
ENV TZ=${TZ}

COPY bin /opt/bin
RUN chmod a+x /opt/bin/entrypoint.sh

RUN if [ "$BUILD_Region" = "cn" ]; then \
    echo "==> BUILD_Region: $BUILD_Region"; \
    bash /opt/bin/${REGION}.debian.sh; \
  fi

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
  apt -y upgrade && \
  apt install -y --no-install-recommends \
    sudo tzdata pkg-config git wget vim netcat curl python3 python3-pip python3-venv && \
  apt -y remove && \
  apt -y autoremove && \
  apt -y clean && \
  apt -y autoclean && \
  dpkg -l | awk '/^rc/{print $2}' | xargs -i dpkg -P {} && \
  rm -rf /var/lib/apt/lists/*

ENV DEBIAN_FRONTEND=dialog

RUN useradd -u 1000 -m -s /bin/bash d2jvkpn && \
  usermod -aG sudo d2jvkpn && \
  mkdir -p /etc/sudoers.d && \
  echo "d2jvkpn ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/d2jvkpn

USER d2jvkpn
ENV PATH=/home/d2jvkpn/.local/bin:$PATH
WORKDIR /home/d2jvkpn

RUN if [ "$BUILD_Region" = "cn" ]; then \
    echo "==> BUILD_Region: $BUILD_Region"; \
    bash /opt/bin/${REGION}.pip.sh; \
  fi

RUN pip3 install --upgrade -r /opt/bin/pip_requirements.txt && \
  rm -rf .cache/pip

# EXPOSE 8080
CMD ["/opt/bin/entrypoint.sh"]
