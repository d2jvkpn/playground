#! /usr/bin/env bash
set -eu -o pipefail

python3 $(dirname $0)/jupyter.py
jupyter lab
