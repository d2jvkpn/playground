#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

container=3dgs_$(tr -dc '0-9a-z' < /dev/urandom | fold -w 8 | head -n 1 || true)

# nvidia/cuda:11.7.1-devel-ubuntu22.04
docker run -d --name $container --gpus=all nvidia/cuda:11.8.0-devel-ubuntu22.04 tail -f /etc/hosts
## don't use image nvidia/cuda:12.2.0-devel-ubuntu22.04

function remove_container() {
    docker rm -f $container
}
trap 'remove_container' ERR

{
    echo "==> $(date +'%FT%T%:z') docker build start"

    docker exec $container mkdir -p /home/d2jvkpn/3dgs_workspace
    docker cp ./3dgs_install.sh $container:/home/d2jvkpn/
    docker cp ./3dgs_conda.sh $container:/home/d2jvkpn/

    docker exec $container ln -s /opt/gaussian-splatting /home/d2jvkpn/3dgs
    docker exec $container bash /home/d2jvkpn/3dgs_install.sh

    docker commit -p \
      --change='ENV DEBIAN_FRONTEND=nointeractive' \
      --change='ENV TZ=Asia/Shanghai' \
      --change='ENV CONDA_HOME=/opt/conda' \
      --change='ENV PATH=/opt/gaussian-splatting/SIBR_viewers/install/bin:$CONDA_HOME/bin:$PATH' \
      --change='WORKDIR /home/d2jvkpn/3dgs_workspace' \
      $container 3dgs:latest

    docker stop $container && docker rm $container

    echo "==> $(date +'%FT%T%:z') docker build end"
} &> 3dgs.$(date +'%FT%H-%M-%S').log

docker save 3dgs:latest -o 3dgs_latest.tar && pigz -f 3dgs_latest.tar
# docker rmi 3dgs:latest

exit

[ ! -z "${AWS_Bucket:-""}" ] && aws s3 cp ./3dgs_latest.tar.gz s3://${AWS_Bucket}/tests/
[ ! -z "${EXIT_Command:=""}" ] && $EXIT_Command

aws s3 ls --recursive s3://${AWS_Bucket}/tests
aws s3 presign s3://${AWS_Bucket}/tests/3dgs_latest.tar.gz
aws s3 rm s3://${AWS_Bucket}/tests/3dgs_latest.tar.gz

# docker run --name 3dgs -d --gpus=all 3dgs:latest tail -f /etc/hosts
docker run --name 3dgs -it --gpus=all -v $PWD:/home/d2jvkpn/3dgs 3dgs:latest bash
