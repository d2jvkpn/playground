#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)




docker run --gpus all -it --rm \
  pytorch/pytorch:2.4.0-cuda12.1-cudnn8-runtime


ls ../containers/jupyter/ubuntu20.04
