FROM golang:1-alpine AS builder

ARG DOCKER_Region=${DOCKER_Region}
ARG GO_ldflags=${GO_ldflags}
ARG APP=${APP}
ENV TZ="Asia/Shanghai"

LABEL stage=${APP}_builder

RUN if [ "$DOCKER_Region" = "cn" ]; then \
    echo "==> DOCKER_Region: $DOCKER_Region"; \
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories; \
    go env -w GOPROXY="https://goproxy.cn,direct"; \
  fi

RUN { apk --no-cache update && apk --no-cache upgrade; } &> /dev/null

WORKDIR /opt/$APP

ADD ./main.go ./go.mod ./go.sum ./project.yaml  ./
COPY ./internal ./internal
# COPY ./pkg      ./pkg
# COPY ./proto    ./proto
COPY ./vendor     ./vendor

# in alpine, date doesn't parse %:z
RUN go build -o main -ldflags="-w -s ${GO_ldflags}" main.go

####
FROM alpine

ARG DOCKER_Region=${DOCKER_Region}
ARG APP=${APP}
ENV TZ="Asia/Shanghai"

RUN if [ "$DOCKER_Region" = "cn" ]; then \
    echo "==> DOCKER_Region: $DOCKER_Region"; \
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories; \
  fi

RUN { apk --no-cache update && apk --no-cache upgrade && apk --no-cache add tzdata; } &> /dev/null

RUN adduser -D -u 1000 d2jvkpn
USER d2jvkpn
WORKDIR /home/d2jvkpn/$APP

COPY --from=builder /opt/$APP/main ./main
# COPY ./migrations ./migrations

EXPOSE 5030
CMD ["./main", "-config=configs/prod.yaml", "-release", "-addr=:5030"]
