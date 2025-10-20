#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


####
mkdir -p data
git clone git@github.com:weaviate/weaviate.git data/weaviate.git

####
cd data/weaviate.git
docker build -f Dockerfile -t local/weaviate:latest ./

####
ollama pull all-minilm

####
pip install -U weaviate-client ollama
