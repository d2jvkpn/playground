#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

name=python_dev

mkdir -p ~/dev/$name
cd ~/dev/$name

# docker run -d --name python_container python:3.10 tail -f /dev/null
# docker run -d --name python_container python:3.10 tail -f /etc/hosts

docker run -d --restart=always \
  --name=$name -h=$name \
  -v=$PWD:/mnt/$name -w=/mnt/$name \
  python:3.10 sleep infinity

exit

docker exec -it $name bash

pip3 config set global.index-url 'https://pypi.douban.com/simple/'
pip3 config set install.trusted-host 'pypi.douban/simple'
pip3 config list

pip install --upgrade pip
pip3 install ipython
