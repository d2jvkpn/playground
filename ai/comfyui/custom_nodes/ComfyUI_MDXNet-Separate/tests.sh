#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


audio-separator input/source.wav --output_format=wav \
  --model_filename=UVR_MDXNET_KARA_2.onnx --model_file_dir=models/AI4future/RVC \
  --output_dir=output --output_bitrate=160
