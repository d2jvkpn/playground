_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

# export TZ=Asia/Shanghai
# export CONDA_HOME=/opt/conda
# export PATH=/opt/gaussian-splatting/SIBR_viewers/install/bin:$CONDA_HOME/bin:$PATH

conda init bash
exec bash
conda activate gaussian_splatting

# echo "==> CONDA_DEFAULT_ENV=$CONDA_DEFAULT_ENV, CONDA_PREFIX=$CONDA_PREFIX, CONDA_HOME=$CONDA_HOME"
# exec "$@"
