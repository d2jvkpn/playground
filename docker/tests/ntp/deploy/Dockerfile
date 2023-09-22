####
FROM golang:1.17-alpine AS builder
LABEL stage=ntp_builder

ENV TZ="Asia/Shanghai"

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN apk --no-cache update && apk --no-cache upgrade && apk --no-cache add tzdata
RUN go env -w GOPROXY="https://goproxy.cn,direct"

WORKDIR /opt/ntp/
COPY go.mod  ./
COPY go.sum  ./
COPY main.go ./
COPY cmd/     ./cmd/
RUN go build -o main  main.go

####
FROM alpine
ENV TZ="Asia/Shanghai"
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN apk --no-cache update && apk --no-cache upgrade && apk --no-cache add tzdata

WORKDIR /opt/ntp/
COPY --from=builder /opt/ntp/main ./main

# EXPOSE 8080
CMD ["./main", "server", "--port", "8080"]
