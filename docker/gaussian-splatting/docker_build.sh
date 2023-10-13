#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

container=3dgs_$(tr -dc '0-9a-z' < /dev/urandom | fold -w 8 | head -n 1 || true)

docker run -d --name $container --gpus=all nvidia/cuda:11.8.0-devel-ubuntu22.04 tail -f /etc/hosts

function remove_container() {
    docker rm -f $container
}

trap 'remove_container' ERR

# nvidia/cuda:11.7.1-devel-ubuntu22.04
{
    echo "==> $(date +'%FT%T%:z') docker build start"
    # docker build -f Dockerfile -t 3dgs ./

    ## not working:
    # docker run -tid --name 3dgs --gpus=all nvidia/cuda:12.2.0-devel-ubuntu22.04 bash

    docker exec $container mkdir -p /data/workspace
    docker cp ./build_app.sh $container:/opt/build_app.sh
    docker cp ./conda_3dgs.sh $container:/data/conda_3dgs.sh
    docker exec $container bash /opt/build_app.sh

    docker commit -p \
      --change='ENV TZ=Asia/Shanghai' \
      --change='ENV CONDA_HOME=/opt/conda' \
      --change='ENV PATH=/opt/gaussian-splatting/SIBR_viewers/install/bin:$CONDA_HOME/bin:$PATH' \
      --change='WORKDIR /data/workspace' \
      $container 3dgs:latest

    docker stop $container && docker rm $container

    echo "==> $(date +'%FT%T%:z') docker build end"
} &> 3dgs.$(date +'%FT%H-%M-%S').log

docker save 3dgs:latest -o 3dgs_latest.tar && pigz 3dgs_latest.tar
docker rmi 3dgs:latest

exit

aws s3 cp ./3dgs_latest.tar.gz s3://$bucket/tests/
aws s3 ls --recursive s3://$bucket/tests
aws s3 presign s3://$bucket/tests/3dgs_latest.tar.gz
aws s3 rm s3://$bucket/tests/3dgs_latest.tar.gz

docker run --name 3dgs -d --gpus=all 3dgs:latest tail -f /etc/hosts

cat << 'EOF'
export TZ=Asia/Shanghai
export CONDA_HOME=/opt/conda
export PATH=/opt/gaussian-splatting/SIBR_viewers/install/bin:$CONDA_HOME/bin:$PATH

conda init bash
exec bash
conda activate gaussian_splatting

echo "==> CONDA_DEFAULT_ENV=$CONDA_DEFAULT_ENV, CONDA_PREFIX=$CONDA_PREFIX, CONDA_HOME=$CONDA_HOME"
exec "$@"
EOF
