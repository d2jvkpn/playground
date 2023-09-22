# Dockerfile
FROM node:lts-alpine AS builder
LABEL stage=vue-web_builder

ARG mode=${mode}
ARG VUE_APP_BuildTime=${VUE_APP_BuildTime}

WORKDIR /opt/vue-web

ADD  *.js *.json .env.*  ./
COPY public/  ./public
COPY src/     ./src

RUN npm install --registry=https://registry.npm.taobao.org &> /dev/null
RUN node_modules/.bin/vue-cli-service build --mode ${mode}.x

####
FROM nginx:stable-alpine

WORKDIR /opt/nginx-web
COPY --from=builder /opt/vue-web/dist ./

RUN mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.bk
COPY deployments/nginx-web.conf /etc/nginx/conf.d/

EXPOSE 80
