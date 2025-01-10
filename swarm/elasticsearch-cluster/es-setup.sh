#!/bin/bash
set -e

cd /usr/share/elasticsearch

if [ ! -f config/certs/ca.zip ]; then
    echo "==> Creating CA";

    elasticsearch-certutil ca --silent --pem -out config/certs/ca.zip;
    unzip config/certs/ca.zip -d config/certs;
fi;

if [ ! -f config/certs/certs.zip ]; then
    echo "==> Creating certs";

    elasticsearch-certutil cert --silent --pem \
      --ca-cert config/certs/ca/ca.crt --ca-key config/certs/ca/ca.key \
      --in ./elastic.yaml \
      -out config/certs/certs.zip;

    unzip config/certs/certs.zip -d config/certs;
fi;

echo "==> Setting file permissions"
chown -R elasticsearch:root config/certs;
chown -R elasticsearch:root data;
#find . -type d -exec chmod 750 \{\} \;;
#find . -type f -exec chmod 640 \{\} \;;

echo "==> All done!";
