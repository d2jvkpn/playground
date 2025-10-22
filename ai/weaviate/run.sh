#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


#### build image
mkdir -p data
git clone git@github.com:weaviate/weaviate.git data/weaviate.git

cd data/weaviate.git
docker build -f Dockerfile -t local/weaviate:latest ./

#### ollama
ollama pull all-minilm

#### pip
pip install -U weaviate-client ollama
