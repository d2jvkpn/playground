#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

mkdir -p data
#python3 -m venv data/venv
#. data/venv/bin/activate

pip install demucs


export TORCH_HOME=$PWD/data/models/torch
ls -1 data/models/torch/hub/checkpoints

demucs -n htdemucs data/source.wav -o data

ls -1 data/htdemucs/source/
# bass.wav
# drums.wav
# other.wav
# vocals.wav

#demucs -n htdemucs --repo ./models/demucs --two-stems=vocals input/source.wav -o output/demucs
#demucs -n htdemucs --repo /path/to/local_demucs_repo input.wav
