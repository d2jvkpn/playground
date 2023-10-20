#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

pb_version=${pb_version:-24.3}
pb_go_version=${pb_go_version:-1.31.0}

####
if ! command protoc &> /dev/null; then
    wget -P ~/Downloads \
      https://github.com/protocolbuffers/protobuf/releases/download/v${pb_version}/protoc-${pb_version}-linux-x86_64.zip

    mkdir -p ~/Apps/protoc-${pb_version}
    unzip ~/Downloads/protoc-${pb_version}-linux-x86_64.zip -f -d ~/Apps/protoc-${pb_version}
fi

# go install google.golang.org/protoc-gen-go@latest
wget -P ~/Downloads \
  https://github.com/protocolbuffers/protobuf-go/releases/download/v${pb_go_version}/protoc-gen-go.v${pb_go_version}.linux.amd64.tar.gz

tar -xf ~/Downloads/protoc-gen-go.v${pb_go_version}.linux.amd64.tar.gz -C ~/Apps/bin

go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
