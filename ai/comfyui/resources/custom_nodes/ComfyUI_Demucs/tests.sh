#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

export TORCH_HOME=$PWD/models/torch
demucs -n htdemucs input/source.wav -o output/demucs

demucs -n htdemucs --repo ./models/demucs --two-stems=vocals input/source.wav -o output/demucs

demucs -n htdemucs --repo /path/to/local_demucs_repo input.wav
