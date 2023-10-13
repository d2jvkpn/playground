#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

container=gaussian-splatting_$(tr -dc '0-9a-z' < /dev/urandom | fold -w 8 | head -n 1 || true)

# nvidia/cuda:11.7.1-devel-ubuntu22.04
{
    echo "==> $(date +'%FT%T%:z') docker build start"
    # docker build -f Dockerfile -t gaussian-splatting ./

    docker run -d --name $container --gpus=all nvidia/cuda:11.8.0-devel-ubuntu22.04 \
      tail -f /etc/hosts

    ## not working:
    # docker run -tid --name gaussian-splatting --gpus=all nvidia/cuda:12.2.0-devel-ubuntu22.04 bash

    docker exec $container mkdir -p /data/workspace
    docker cp ./build_app.sh $container:/opt/build_app.sh
    docker cp ./conda_env.sh $container:/data/conda_env.sh
    docker exec $container bash /opt/build_app.sh

    docker commit -p \
      --change='ENV TZ=Asia/Shanghai' \
      --change='ENV CONDA_HOME=/opt/conda' \
      --change='ENV PATH=$CONDA_HOME/bin:$PATH' \
      --change='ENV PATH=/opt/gaussian-splatting/SIBR_viewers/install/bin:$PATH' \
      --change='WORKDIR /data/workspace' \
      --change='ENTRYPOINT ["sleep", "infinity"]' \
      $container gaussian-splatting:latest
    # --change='ENTRYPOINT ["tail", "-f", "/etc/hosts"]'

    docker stop $container && docker rm $container

    echo "==> $(date +'%FT%T%:z') docker build end"
} &> gaussian-splatting.$(date +'%FT%H-%M-%S').log

docker save gaussian-splatting:latest -o gaussian-splatting_latest.tar
pigz gaussian-splatting_latest.tar
docker rmi gaussian-splatting:latest

exit

aws s3 cp ./gaussian-splatting_latest.tar.gz s3://$bucket/tests/
aws s3 ls --recursive s3://$bucket/tests
aws s3 presign s3://$bucket/tests/gaussian-splatting_latest.tar.gz
aws s3 rm s3://$bucket/tests/gaussian-splatting_latest.tar.gz

docker run --name 3dgs -d --gpus=all gaussian-splatting:latest

cat << 'EOF'
export TZ=Asia/Shanghai
export CONDA_HOME=/opt/conda
export PATH=$CONDA_HOME/bin:$PATH
export PATH=/opt/gaussian-splatting/SIBR_viewers/install/bin:$PATH

conda init bash
exec bash
conda activate gaussian_splatting
echo "==> conda: CONDA_DEFAULT_ENV=$CONDA_DEFAULT_ENV, CONDA_PREFIX=$CONDA_PREFIX, CONDA_HOME=$CONDA_HOME"
exec "$@"
EOF
