# Dockerfile

#### stage 1
FROM node:lts-alpine AS builder
LABEL stage=react-web_builder

ARG APP_ENV=${APP_ENV}
ARG ENV_File=${ENV_File}
ARG REACT_APP_BuildTime=${REACT_APP_BuildTime}
ENV TZ=Asia/Shanghai

# RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
# RUN { apk --no-cache update && apk --no-cache upgrade && apk --no-cache add tzdata; } &> /dev/null

WORKDIR /app/react-web
ADD *.json  react_build.sh yarn.lock ./
COPY  configs/  ./configs
COPY  public/   ./public
COPY  src/      ./src

# RUN npm install --global yarn --registry=https://registry.npmmirror.com
RUN yarn install --registry=https://registry.npmmirror.com &> /dev/null
RUN sh react_build.sh $ENV_File # bash isn't installed in apline in default

#### stage 2
FROM nginx:stable-alpine

WORKDIR /app/react-web
# COPY /app/react-web/build  /usr/share/nginx/html
COPY --from=builder /app/react-web/build ./

# events {
# 	worker_connections  1024;
# }

RUN sed -i '/worker_processes/s#auto#4#' /etc/nginx/nginx.conf
RUN mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.bk
COPY deployments/react-web.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
