FROM alpine:3

ENV TZ=${TZ:-Asia/Shanghai}

RUN if [ "$BUILD_Region" = "cn" ]; then \
    echo "==> BUILD_Region: $BUILD_Region"; \
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories; \
  fi

RUN apk --no-cache update && \
  apk --no-cache upgrade && \
  apk --no-cache add tzdata gcompat curl
  # wget

RUN mkdir -p /app
WORKDIR /app

CMD ["/bin/sh"]
