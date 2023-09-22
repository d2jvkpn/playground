#! /usr/bin/env bash
set -eu -o pipefail


mkdir -p auth data

apt install apache2-utils
# htpasswd -Bbn USERNAME PASSWORD >> auth/htpasswd
# htpasswd -Bbn USERNAME >> auth/htpasswd
htpasswd -Bc auth/htpasswd USERNAME

exit

DOMAIN=xxxx

docker pull alpine:3
docker tag alpine:3 $DOMAIN/alpine:3
docker push $DOMAIN/alpine:3

docker login ${DOMAIN}

# append /etc/docker/daemon.json.{.registry-mirrors}    http://localhost:5000
# append /etc/docker/daemon.json.{.insecure-registries} http://localhost:5000

# https://$DOMAIN/v2/alpine/tags/list
# https://$DOMAIN/v2/_catalog
# https://$DOMAIN/v2/alpine/tags/list

docker run -d \
  -p 5000:5000 \
  --restart=always \
  --name registry \
  -v "$(pwd)"/auth:/auth \
  -e "REGISTRY_AUTH=htpasswd" \
  -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
  -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
  -v "$(pwd)"/certs:/certs \
  -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.crt \
  -e REGISTRY_HTTP_TLS_KEY=/certs/domain.key \
  registry:2
