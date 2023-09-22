FROM rust:1-slim-buster

ENV TZ="Asia/Shanghai"

RUN mkdir -p /root/.cargo
ADD cargo_config /root/.cargo/config

RUN cp /etc/apt/sources.list /etc/apt/sources.list.bk && \
  sed -i 's#http://\(deb\|security\).debian.org#https://mirrors.aliyun.com#g' \
  /etc/apt/sources.list

RUN  apt -y update && \
  apt -y upgrade && \
  apt install -y musl-tools && \
  apt clean && \
  apt autoclean && \
  apt remove && \
  apt autoremove
