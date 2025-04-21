#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

instances_yaml=${1:-config/certs/instances.yaml}

cd /usr/share/elasticsearch

if [ ! -s config/certs/ca.crt ]; then
    echo "==> Creating CA";

    elasticsearch-certutil ca --silent --pem -out config/certs/ca.zip;
    unzip -j config/certs/ca.zip "ca/*" -d config/certs/
fi;

if [ ! -f config/certs/certs.zip ]; then
    echo "==> Creating certs";

    elasticsearch-certutil cert --silent --pem \
      --ca-cert config/certs/ca.crt \
      --ca-key config/certs/ca.key \
      --in $instances_yaml \
      -out config/certs/certs.zip;

    # unzip -j config/certs/certs.zip "*/*" -d config/certs;
    # for crt in $(ls config/certs/*.crt | grep -v "config/certs/ca.crt"); do ...; done
    unzip config/certs/certs.zip -d config/certs;

    echo "==> Modifing certs of nodes"
    for crt in $(ls config/certs/*/*.crt | grep -v "config/certs/ca.crt"); do
        node=$(basename $crt .crt);

        cat config/certs/ca.crt >> $crt;
        mv config/certs/$node/$node.crt config/certs/$node/node.crt;
        mv config/certs/$node/$node.key config/certs/$node/node.key;
    done
fi;

echo "==> Setting file permissions"
chown -R elasticsearch:root config/certs;
#find . -type d -exec chmod 750 \{\} \;;
#find . -type f -exec chmod 640 \{\} \;;

chmod 600 config/certs/elastic.pass

echo "==> All done!";
