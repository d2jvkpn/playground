FROM golang:1-alpine AS builder

ARG BUILD_Region=${BUILD_Region}
ARG GO_ldflags=${GO_ldflags}
ARG APP_Name=${APP_Name}
ARG APP_Version=${APP_Version}
ENV TZ=${TZ:-Asia/Shanghai}

LABEL stage=${APP_Name}_builder

RUN if [ "$BUILD_Region" = "cn" ]; then \
    echo "==> BUILD_Region: $BUILD_Region"; \
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories; \
    go env -w GOPROXY="https://goproxy.cn,direct"; \
  fi

RUN { apk --no-cache update && apk --no-cache upgrade; } &> /dev/null

WORKDIR /opt/$APP_Name

ADD ./main.go ./go.mod ./go.sum ./project.yaml  ./
COPY ./internal ./internal
# COPY ./pkg ./pkg
# COPY ./migrations ./migrations
COPY ./proto ./proto
COPY ./vendor ./vendor

# in alpine, date doesn't parse %:z
RUN go build -o main -ldflags="-w -s ${GO_ldflags}" main.go

####
FROM alpine

ARG BUILD_Region=${BUILD_Region}
ARG APP_Name=${APP_Name}
ARG APP_Version=${APP_Version}
ENV TZ=${TZ:-Asia/Shanghai}

RUN if [ "$BUILD_Region" = "cn" ]; then \
    echo "==> BUILD_Region: $BUILD_Region"; \
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories; \
  fi

RUN { apk --no-cache update && apk --no-cache upgrade && apk --no-cache add tzdata; } &> /dev/null
RUN apk --no-cache add curl &> /dev/null

RUN adduser -D -u 1000 d2jvkpn
USER d2jvkpn
WORKDIR /home/d2jvkpn/$APP_Name

COPY --from=builder /opt/$APP_Name/main ./main
# COPY ./migrations ./migrations

EXPOSE 5030
CMD ["./main", "-config=configs/prod.yaml", "-release", "-addr=:5030"]
