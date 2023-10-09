package internal

import (
	// "fmt"

	"go.uber.org/zap"
	"google.golang.org/grpc"
	"gorm.io/gorm"
)

var (
	_Logger       *zap.Logger
	_DB           *gorm.DB
	_ConsulClient *wrap.ConsulClient
	_CloseTracer  func()
	_GrpcServer   *grpc.Server
)
