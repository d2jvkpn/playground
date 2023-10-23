FROM golang:1-alpine AS builder

ENV TZ=${TZ:-Asia/Shanghai}
ARG APP_Name=${APP_Name}
ARG APP_Version=${APP_Version}
ARG BUILD_Region=${BUILD_Region}
ARG GO_ldflags=${GO_ldflags}

LABEL stage=${APP_Name}_builder

RUN if [ "$BUILD_Region" = "cn" ]; then \
    echo "==> BUILD_Region: $BUILD_Region"; \
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories; \
    go env -w GOPROXY="https://goproxy.cn,direct"; \
  fi

RUN apk --no-cache update && \
  apk --no-cache upgrade

WORKDIR /opt/$APP_Name

ADD ./main.go ./go.mod ./go.sum ./project.yaml  ./
COPY ./internal ./internal
COPY ./pkg ./pkg
COPY ./migrations ./migrations
COPY ./proto ./proto
COPY ./vendor ./vendor

# in alpine, date doesn't parse %:z
RUN go build -o main -ldflags="-w -s ${GO_ldflags}" main.go

####
FROM alpine

ENV TZ=${TZ:-Asia/Shanghai}
ARG APP_Name=${APP_Name}
ARG APP_Version=${APP_Version}
ARG BUILD_Region=${BUILD_Region}

RUN if [ "$BUILD_Region" = "cn" ]; then \
    echo "==> BUILD_Region: $BUILD_Region"; \
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories; \
  fi

RUN apk --no-cache update && \
  apk --no-cache upgrade && \
  apk --no-cache add tzdata curl

# RUN adduser -D -u 1000 d2jvkpn
# USER d2jvkpn
RUN mkdir -p /home/d2jvkpn/$APP_Name
WORKDIR /home/d2jvkpn/$APP_Name

COPY --from=builder /opt/$APP_Name/main ./main
COPY ./migrations ./migrations

EXPOSE 5030 5040
CMD ["./main", "-config=configs/prod.yaml", "-release", "-http_addr=:5030", "-rpc_addr=:5040"]
