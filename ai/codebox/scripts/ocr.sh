#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


pip install --no-cache-dir --upgrade tesseract-ocr

sudo apt install tesseract-ocr \
  tesseract-ocr-eng tesseract-ocr-chi-sim tesseract-ocr-chi-tra

#eng       英文
#chi_sim   简体中文
#chi_tra   繁体中文
#jpn       日文
#kor       韩文
