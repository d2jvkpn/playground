FROM golang:1-alpine AS builder
LABEL stage=http-auth-proxy_builder

ARG BUILD_Region=${BUILD_Region}
ARG GO_ldflags=${GO_ldflags}
ENV APP_NAME=http-auth-proxy
ENV TZ="Asia/Shanghai"

RUN if [ "$BUILD_Region" = "cn" ]; then \
    echo "==> BUILD_Region: cn"; \
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories; \
    go env -w GOPROXY="https://goproxy.cn,direct"; \
  fi

RUN { apk --no-cache update && apk --no-cache upgrade; } &> /dev/null

WORKDIR /app

ADD ./go.mod ./go.sum ./main.go ./project.yaml  ./
COPY ./pkg ./pkg

# in alpine, date doesn't parse %:z
RUN mkdir -p target && \
  go build -o target/main -ldflags="-w -s ${GO_ldflags}" main.go

####
FROM alpine

ARG BUILD_Region=${BUILD_Region}
ENV APP_NAME=http-auth-proxy
ENV TZ="Asia/Shanghai"

RUN if [ "$BUILD_Region" = "cn" ]; then \
    echo "==> BUILD_Region: cn"; \
    cp /etc/apk/repositories /etc/apk/repositories.bk; \
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories; \
  fi

RUN apk --no-cache update && \
  apk --no-cache upgrade && \
  apk --no-cache add tzdata

WORKDIR /app

COPY --from=builder /app/target/main ./target/main

EXPOSE 9000
CMD ["./target/main", "-addr=:5010", "-config=configs/prod.yaml", "-release"]
