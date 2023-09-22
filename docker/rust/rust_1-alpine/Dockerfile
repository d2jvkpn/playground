FROM rust:1-alpine

ENV TZ="Asia/Shanghai"

RUN mkdir -p /root/.cargo
ADD cargo_config /root/.cargo/config

RUN cp /etc/apk/repositories /etc/apk/repositories.bk && \
  sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
  { apk --no-cache update && apk --no-cache upgrade; apk --no-cache add musl-dev; } &> /dev/null
