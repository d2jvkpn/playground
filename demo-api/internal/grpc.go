package internal

import (
	// "fmt"
	"context"
	"net"

	"demo-api/proto"

	"github.com/d2jvkpn/gotk/cloud-logging"
	grpc_middleware "github.com/grpc-ecosystem/go-grpc-middleware"
	"github.com/spf13/viper"
	"go.opentelemetry.io/contrib/instrumentation/google.golang.org/grpc/otelgrpc"
	"go.uber.org/zap"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials"
	"google.golang.org/grpc/health"
	"google.golang.org/grpc/health/grpc_health_v1"
)

type RPCServer struct {
	config     *viper.Viper
	logger     *zap.Logger
	serverOpts []grpc.ServerOption
	server     *grpc.Server
}

func NewRPCServer(config *viper.Viper, logger *zap.Logger, otel bool) (srv *RPCServer, err error) {
	//
	srv = &RPCServer{
		config: config,
		logger: logger.Named("data"),
	}

	//
	interceptor := logging.NewGrpcSrvLogger(logger.Named("log"))

	uIntes := []grpc.UnaryServerInterceptor{interceptor.Unary()}
	if otel {
		uIntes = append(uIntes, otelgrpc.UnaryServerInterceptor( /*opts ...Option*/ ))
	}

	sIntes := []grpc.StreamServerInterceptor{interceptor.Stream()}
	if otel {
		sIntes = append(sIntes, otelgrpc.StreamServerInterceptor( /*opts ...Option*/ ))
	}

	srv.serverOpts = []grpc.ServerOption{
		grpc.UnaryInterceptor(grpc_middleware.ChainUnaryServer(uIntes...)),
		grpc.StreamInterceptor(grpc_middleware.ChainStreamServer(sIntes...)),
	}

	//
	if srv.config.GetBool("tls") {
		var creds credentials.TransportCredentials
		creds, err = credentials.NewServerTLSFromFile(
			srv.config.GetString("cert"),
			srv.config.GetString("key"),
		)
		if err != nil {
			return nil, err
		}
		srv.serverOpts = append(srv.serverOpts, grpc.Creds(creds))
	}

	return srv, nil
}

func (srv *RPCServer) New(ctx context.Context, record *proto.LogData) (*proto.LogId, error) {
	fields := []zap.Field{
		zap.String("name", record.Name),
		zap.String("version", record.Version),
		zap.Any("http", map[string]any{
			"ip": record.Ip, "request_id": record.RequestId, "request_at": record.RequestAt,
			"query": record.Query, "status_code": record.StatusCode, "latency": record.Latency,
		}),
		zap.Any("identity", record.Identity),
		zap.ByteString("data", record.Data),
	}

	switch {
	case record.StatusCode < 400:
		srv.logger.Info(record.Msg, fields...)
	case record.StatusCode >= 400 && record.StatusCode < 500:
		srv.logger.Warn(record.Msg, fields...)
	default: // record.StatusCode >= 500
		srv.logger.Error(record.Msg, fields...)
	}

	return &proto.LogId{Id: ""}, nil
}

func (srv *RPCServer) Addr() string {
	return srv.config.GetString("addr")
}

func (srv *RPCServer) Serve(listener net.Listener) (err error) {
	srv.server = grpc.NewServer(srv.serverOpts...)
	proto.RegisterLogServiceServer(srv.server, srv)

	grpc_health_v1.RegisterHealthServer(srv.server, health.NewServer())

	return srv.server.Serve(listener)
}

func (srv *RPCServer) Shutdown() {
	if srv.server != nil {
		srv.server.GracefulStop()
	}
}
