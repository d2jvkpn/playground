####
FROM golang:1-alpine AS builder

ARG APP_Name
ARG BUILD_Region

LABEL stage=${APP_Name}_builder

RUN if [ "$BUILD_Region" = "cn" ]; then \
    echo "==> BUILD_Region: $BUILD_Region"; \
    cp /etc/apk/repositories /etc/apk/repositories.bk; \
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories; \
    go env -w GOPROXY="https://goproxy.cn,direct"; \
  fi

RUN apk --no-cache update && \
  apk --no-cache upgrade

WORKDIR /app

COPY ./frp.git /app
COPY ./cache.local ./cache.local

RUN if [ -d ./cache.local/vendor ]; then \
    echo "==> Found cache.local/vendor"; \
    mv ./cache.local/vendor vendor; \
  fi

RUN mkdir -p target
RUN go build -trimpath -ldflags "-w -s" -tags frpc -o target/frpc ./cmd/frpc
RUN go build -trimpath -ldflags "-w -s" -tags frps -o target/frps ./cmd/frps

####
FROM alpine:3

ARG APP_Name
ARG BUILD_Region

ENV TZ=${TZ:-Asia/Shanghai}
ENV APP_Name=${APP_Name}
ENV BUILD_Region=${BUILD_Region}

RUN if [ "$BUILD_Region" = "cn" ]; then \
    echo "==> BUILD_Region: $BUILD_Region"; \
    cp /etc/apk/repositories /etc/apk/repositories.bk; \
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories; \
  fi

RUN apk --no-cache update && \
  apk --no-cache upgrade && \
  apk --no-cache add tzdata
  # curl

RUN mkdir -p /app/target
WORKDIR /app

COPY --from=builder /app/target/ /app/target/
COPY --from=builder /app/cache.local/build.yaml /app/

EXPOSE 3050 3051

# CMD [./target/frpc, --config=configs/frp_client.toml]
# CMD [./target/frps, --config=configs/frp_server.toml]
