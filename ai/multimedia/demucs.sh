#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


pip install demucs

demucs -n htdemucs --two-stems=vocals source.wav
ls separated/htdemucs/source/{no_vocals.wav,vocals.wav}
