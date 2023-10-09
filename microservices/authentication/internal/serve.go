package internal

import (
	"fmt"
	"net"
	// "time"

	"authentication/internal/models"
	"authentication/internal/settings"
	"authentication/pkg/orm"
	. "authentication/proto"

	"github.com/d2jvkpn/gotk/cloud-logging"
	"github.com/d2jvkpn/gotk/cloud-tracing"
	grpc_middleware "github.com/grpc-ecosystem/go-grpc-middleware"
	"github.com/spf13/viper"
	"go.opentelemetry.io/contrib/instrumentation/google.golang.org/grpc/otelgrpc"
	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
	"google.golang.org/grpc"
)

// database => tracing => grpc.Server => service registry => logger
func ServeAsync(addr string, meta map[string]any, errch chan<- error) (err error) {
	var (
		otelEnabled bool
		listener    net.Listener
	)

	// database
	dsn := settings.Config.GetString("postgres.conn") + "/" +
		settings.Config.GetString("postgres.db")

	if _DB, err = models.Connect(dsn, !settings.Release); err != nil {
		return err
	}

	// opentelemetry
	if otelEnabled, _CloseTracer, err = setupOtel(settings.Config); err != nil {
		return err
	}

	// grpc
	if listener, err = net.Listen("tcp", addr); err != nil {
		return err
	}

	_GrpcServer = grpc.NewServer(setupInterceptors(otelEnabled)...)
	srv := models.NewServer()
	RegisterAuthServiceServer(_GrpcServer, srv)

	// logger
	if settings.Release {
		settings.Logger, err = logging.NewLogger("logs/authentication.log", zapcore.InfoLevel, 256)
	} else {
		settings.Logger, err = logging.NewLogger("logs/authentication.log", zapcore.DebugLevel, 256)
	}
	if err != nil {
		return err
	}
	_Logger = settings.Logger.Named("server")

	_Logger.Info(
		"Server is starting",
		zap.Bool("otelEnabled", otelEnabled),
		zap.Any("meta", meta),
	)

	// serve
	go func() {
		err := _GrpcServer.Serve(listener)
		errch <- err
	}()

	return nil
}

func setupInterceptors(enableOtel bool) []grpc.ServerOption {
	interceptor := models.NewInterceptor()

	uIntes := make([]grpc.UnaryServerInterceptor, 0, 2)
	sIntes := make([]grpc.StreamServerInterceptor, 0, 2)

	if enableOtel {
		uIntes = append(uIntes, otelgrpc.UnaryServerInterceptor( /*opts ...Option*/ ))
		sIntes = append(sIntes, otelgrpc.StreamServerInterceptor( /*opts ...Option*/ ))
	}
	// grpc.UnaryInterceptor(otelgrpc.UnaryServerInterceptor()),
	// grpc.StreamInterceptor(otelgrpc.StreamServerInterceptor()),
	uIntes = append(uIntes, interceptor.Unary())
	sIntes = append(sIntes, interceptor.Stream())

	uInte := grpc_middleware.ChainUnaryServer(uIntes...)
	sInte := grpc_middleware.ChainStreamServer(sIntes...)
	return []grpc.ServerOption{grpc.UnaryInterceptor(uInte), grpc.StreamInterceptor(sInte)}
}

func setupOtel(vc *viper.Viper) (enabled bool, closeTracer func() error, err error) {
	if !vc.GetBool("opentelemetry.enable") {
		return false, nil, nil
	}

	str := vc.GetString("opentelemetry.address")
	secure := vc.GetBool("opentelemetry.secure")

	closeTracer, err = tracing.LoadOtelGrpc(str, settings.App, secure)
	if err != nil {
		return true, nil, fmt.Errorf("cloud_native.LoadTracer: %s, %w", str, err)
	}

	return true, closeTracer, nil
}

// service registry => grpc.Server => tracing => database => logger
func Shutdown() {
	var err error

	errorf := func(format string, a ...any) {
		if _Logger == nil {
			return
		}
		_Logger.Error(fmt.Sprintf(format, a...))
	}

	infof := func(format string, a ...any) {
		if _Logger == nil {
			return
		}
		_Logger.Info(fmt.Sprintf(format, a...))
	}

	if _GrpcServer != nil {
		infof("stop grpc server")
		_GrpcServer.GracefulStop()
	}

	if _CloseTracer != nil {
		infof("close tracer")
		_CloseTracer()
	}

	if _DB != nil {
		if err = orm.CloseDB(_DB); err != nil {
			errorf(fmt.Sprintf("close database: %v", err))
		} else {
			infof("close database")
		}
	}

	infof("close logger")
	if settings.Logger != nil {
		settings.Logger.Down()
	}
}
