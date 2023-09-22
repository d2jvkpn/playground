#! /usr/bin/env bash
set -eu -o pipefail

docker pull ubuntu:20.04

image="registry.cn-shanghai.aliyuncs.com/d2jvkpn/jupyter:ubuntu20.04"
docker build --no-cache -t $image .
sudo docker push $image
