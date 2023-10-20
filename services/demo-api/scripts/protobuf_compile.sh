#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

export PATH="$HOME/Apps/bin:$(go env GOPATH)/bin:$PATH"

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
	rpc Push(LogData) returns(LogId) {};
}
EOF

protoc --go-grpc_out=./ --go_out=./ --proto_path=./proto proto/*.proto

ls -al proto/
go fmt ./... && go vet ./...

sed -i '/^\tmustEmbedUnimplemented/s#\t#\t// #' proto/*_grpc.pb.go
