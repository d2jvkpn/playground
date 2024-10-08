# Dockerfile
# FROM node:20-alpine AS builder
FROM node:lts-alpine AS builder
LABEL stage=vue-web_builder

WORKDIR /app

# *.env.*
ADD  index.html *.js *.json  ./
COPY public/ ./public
COPY src/ ./src

COPY cache.local ./cache.local
RUN cp cache.local/.env.prod ./

RUN if [ -d ./cache.local/node_modules ]; then \
    echo "==> Found ./cache.local/node_modules"; \
    mv ./cache.local/node_modules ./; \
  fi

# npm config set registry https://registry.npmmirror.com
RUN npm install --registry=https://registry.npmmirror.com &> /dev/null
# RUN node_modules/.bin/vue-cli-service build --mode ${mode}-x
RUN npm run build:prod

####
FROM nginx:1-alpine

WORKDIR /app
ADD cache.local/build.yaml ./

COPY --from=builder /app/dist ./dist

RUN mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.bk
COPY deployments/app.nginx.conf /etc/nginx/conf.d/

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
