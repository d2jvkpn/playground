FROM golang:1-alpine AS builder

ENV TZ=${TZ:-Asia/Shanghai}
ARG APP_Name
ARG APP_Version
ARG BUILD_Region
ARG GO_ldflags

LABEL stage=${APP_Name}_builder

RUN if [ "$BUILD_Region" = "cn" ]; then \
    echo "==> BUILD_Region: $BUILD_Region"; \
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories; \
    go env -w GOPROXY="https://goproxy.cn,direct"; \
  fi

RUN apk --no-cache update && \
  apk --no-cache upgrade

WORKDIR /app

ADD ./main.go ./go.mod ./go.sum ./project.yaml  ./
COPY ./internal ./internal
# COPY ./migrations ./migrations
COPY ./pkg ./pkg
COPY ./proto ./proto

# COPY ./vendor ./vendor
COPY ./cache ./cache
RUN if [ -d ./cache/vendor ]; then echo "==> found vendor"; mv ./cache/vendor vendor; fi

# in alpine, date doesn't parse %:z
# mkdir -p target && go build -o target/main -ldflags="-w -s ${GO_ldflags}" main.go
RUN mkdir -p target && \
  go build -o target/main -ldflags="-w -s ${GO_ldflags}" main.go

####
FROM alpine:3

ARG APP_Name
ARG APP_Version
ARG BUILD_Time
ARG BUILD_Region

ENV TZ=${TZ:-Asia/Shanghai}
ENV APP_Name=${APP_Name}
ENV BUILD_Time=${BUILD_Time}
ENV BUILD_Region=${BUILD_Region}

RUN if [ "$BUILD_Region" = "cn" ]; then \
    echo "==> BUILD_Region: $BUILD_Region"; \
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories; \
  fi

RUN apk --no-cache update && \
  apk --no-cache upgrade && \
  apk --no-cache add tzdata
  # curl

RUN mkdir -p /app/target
WORKDIR /app


COPY --from=builder /app/target/ /app/target/
# COPY ./migrations ./migrations

# http server
EXPOSE 5030
# swagger server
# EXPOSE 5040
# prometheus server
# EXPOSE 5041

CMD [./target/main, -release, -config=configs/prod.yaml, -http.addr=:5030]
