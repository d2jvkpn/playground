# Dockerfile

FROM nginx:stable-alpine

RUN mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.bk
COPY nginx-fileserver.conf /etc/nginx/conf.d/

COPY static /app/static

EXPOSE 80
