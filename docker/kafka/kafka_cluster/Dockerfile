FROM ubuntu:22.04

ENV TZ="Asia/Shanghai"

COPY tmp/kafka_2.13-3.3.1 /opt/kafka
COPY scripts /opt/kafka/scripts

# wget zip net-tools iputils-ping vim nano tar software-properties-common
RUN cp /etc/apt/sources.list /etc/apt/sources.list.bk && \
  sed -i 's#//archive.ubuntu.com#//cn.archive.ubuntu.com#' /etc/apt/sources.list && \
  apt update && apt -y upgrade && \
  apt install -y tzdata netcat ca-certificates default-jdk && \
  apt remove && apt autoremove && apt clean && apt autoclean && \
  rm -rf /var/lib/apt/lists/*

WORKDIR /opt/kafka
EXPOSE 2181 2888 3888 29092
CMD [bin/zookeeper-server-start.sh, config/zookeeper.properties]
