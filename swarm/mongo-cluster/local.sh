#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


# https://tecadmin.net/how-to-install-mongodb-on-ubuntu-22-04/
sudo apt update and sudo apt upgrade
sudo apt install gnupg2

wget -nc https://www.mongodb.org/static/pgp/server-6.0.asc
cat server-6.0.asc | gpg --dearmor | sudo tee /etc/apt/keyrings/mongodb.gpg >/dev/null

echo "deb [arch=amd64,arm64 signed-by=/etc/apt/keyrings/mongodb.gpg] \
https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/6.0 multiverse" > mongo.list

sudo mv mongo.list /etc/apt/sources.list.d/mongo.list

sudo apt update

sudo apt install mongodb-org
sudo systemctl start mongod
