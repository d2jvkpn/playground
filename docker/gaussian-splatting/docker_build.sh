#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

container=3dgs_$(tr -dc '0-9a-z' < /dev/urandom | fold -w 8 | head -n 1 || true)

## cuda version: 11
docker run -d --name $container --gpus=all nvidia/cuda:11.8.0-devel-ubuntu22.04 tail -f /etc/hosts

function remove_container() {
    docker rm -f $container
}
# trap 'remove_container' ERR
trap 'remove_container' EXIT

{
    date +'==> %FT%T%:z docker build start'

    docker exec $container mkdir -p /app/workspace
    docker cp bin $container:/app/bin

    docker exec $container bash /app/bin/3dgs_install.sh
    docker exec $container 'chmod a+x /app/bin/*.sh'
    docker exec $container ln -s /opt/gaussian-splatting /app/3dgs

    docker commit -p \
      --change='ENV DEBIAN_FRONTEND=nointeractive' \
      --change='ENV TZ=Asia/Shanghai' \
      --change='ENV CONDA_HOME=/opt/conda' \
      --change='ENV PATH=/opt/gaussian-splatting/SIBR_viewers/install/bin:$CONDA_HOME/bin:$PATH' \
      --change='WORKDIR /app/workspace' \
      $container 3dgs:latest
      # --change='ENTRYPOINT ["bash", "/app/bin/3dgs_pipeline.sh"]' \

    date +'==> %FT%T%:z docker build end'
} &> 3dgs.$(date +'%FT%H-%M-%S').log

docker stop $container && docker rm $container
docker save 3dgs:latest -o 3dgs_latest.tar && pigz -f 3dgs_latest.tar
# docker rmi 3dgs:latest

exit

####
[ ! -z "${AWS_Bucket:-""}" ] && aws s3 cp ./3dgs_latest.tar.gz s3://${AWS_Bucket}/tests/
[ ! -z "${EXIT_Command:=""}" ] && $EXIT_Command

aws s3 ls --recursive s3://${AWS_Bucket}/tests
aws s3 presign s3://${AWS_Bucket}/tests/3dgs_latest.tar.gz
aws s3 rm s3://${AWS_Bucket}/tests/3dgs_latest.tar.gz

####
docker run --name 3dgs -d --gpus=all 3dgs:latest tail -f /etc/hosts
docker run --name 3dgs -d --gpus=all 3dgs:latest sleep infinity

####
project=my-project

docker run -d --gpus=all \
  --name $project -v $PWD/$project:/app/workspace \
  3dgs:latest bash /app/bin/3dgs_pipeline.sh

ls -d project01/ project02/ project03/

docker run -d --gpus=all \
  --name $project -v $PWD:/app/workspace \
  3dgs:latest bash /app/bin/3dgs_pipeline.sh project01 project02 project03
