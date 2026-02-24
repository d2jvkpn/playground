#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


#### 1. 
addr=$(yq .address configs/local.yaml)

exit
run_id=$(uuid)
subfolder=myjob_$(date +%F)

curl -X POST "$addr/upload/audio" \
  -F "file=@data/inputs/source_01.wav" \
  -F "subfolder=$subfolder"


exit
curl -X POST "http://127.0.0.1:8188/upload/image" \
  -F "file=@a.png" \
  -F "subfolder=myjob/2025-12-23"

curl -X POST "http://127.0.0.1:8188/upload/audio" \
  -F "file=@source.wav" \
  -F "subfolder=myjob/2025-12-23"
