####
FROM alpine:3

ENV TZ="Asia/Shanghai"

RUN cp /etc/apk/repositories /etc/apk/repositories.bk && \
  sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories &&
  apk --no-cache update && apk --no-cache upgrade && apk --no-cache add tzdata gcompat curl
