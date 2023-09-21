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

####
# go install google.golang.org/protoc-gen-go@latest
wget -P ~/Downloads \
  https://github.com/protocolbuffers/protobuf-go/releases/download/v${pb_go_version}/protoc-gen-go.v${pb_go_version}.linux.amd64.tar.gz

tar -xf ~/Downloads/protoc-gen-go.v${pb_go_version}.linux.amd64.tar.gz -C ~/Apps/bin

####
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

export PATH="$PATH:$(go env GOPATH)/bin"

# go get -u github.com/golang/protobuf/{proto,protoc-gen-go}@v1.31.0
go get -u google.golang.org/grpc
go get -u google.golang.org/protobuf

# go get google/protobuf/timestamp.proto

#### create proto
mkdir -p proto

cat > proto/log.proto << EOF
syntax = "proto3";
package proto;

option go_package = "./proto";
// import "google/protobuf/timestamp.proto";

message LogData {
	string name = 1;
	string version = 2;
	string ip = 3;
	string requestId = 4;
	int64  requestAt = 5;
	// google.protobuf.Timestamp requestAt = 5;

	string msg = 6;
	string query = 7;
	int32 status_code = 8;
	string latency = 9;
	map<string, string> identity = 10;
	string error = 11;
	bytes data = 12;
}

message LogId {
	string id = 1;
}

service LogService {
	rpc New(LogData) returns(LogId) {};
}
EOF

#### grpc generate
protoc --go-grpc_out=./ --go_out=./ --proto_path=./proto proto/*.proto

ls -al proto/

go fmt ./... && go vet ./...

#### implment...
sed -i '/^\tmustEmbedUnimplemented/s#\t#\t// #' proto/*_grpc.pb.go
