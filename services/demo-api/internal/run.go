package internal

import (
	"context"
	"fmt"
	"net"
	"net/http"
	// "sync"
	"time"

	"demo-api/internal/settings"

	"github.com/d2jvkpn/gotk"
	"github.com/d2jvkpn/gotk/cloud-tracing"
	"go.uber.org/zap"
)

func Run(httpAddr, rpcAddr string) (errch chan error, err error) {
	var (
		httpListener net.Listener
		rpcListener  net.Listener
	)

	opentel := settings.Config.Sub("opentel")
	if opentel.GetBool("enabled") {
		_CloseOtel, err = tracing.LoadOtelGrpc(
			opentel.GetString("address"),
			settings.Project.GetString("app_name"),
			opentel.GetBool("tls"),
		)

		if err != nil {
			return nil, fmt.Errorf("LoadTracer: %s, %w", opentel.GetString("address"), err)
		}
	}

	if httpListener, err = net.Listen("tcp", httpAddr); err != nil {
		return nil, fmt.Errorf("net.Listen: %w", err)
	}

	if rpcListener, err = net.Listen("tcp", rpcAddr); err != nil {
		return nil, fmt.Errorf("net.Listen: %w", err)
	}

	_RuntimeInfo = gotk.NewRuntimeInfo(func(data map[string]string) {
		_Logger.Info("runtime", zap.Any("data", data))
	}, 60)

	_RuntimeInfo.Start()

	_Logger.Info("services are up", zap.Any("meta", settings.Meta))

	// once := new(sync.Once)
	// shutdown := func() { once.Do(_Shutdown) }
	errch = make(chan error, 2) // let the capacity of channel equals to number of services

	go func() {
		e := _RPC.Serve(rpcListener)
		_RPC = nil // tag as close

		if e == nil {
			_Logger.Warn("RPC server is down")
		} else {
			_Logger.Error("RPC server is down", zap.Any("error", e))
		}

		errch <- e
	}()

	go func() {
		e := _Server.Serve(httpListener)
		_Server = nil // tag as close

		if e != nil && e != http.ErrServerClosed {
			_Logger.Warn("HTTP server is down", zap.Any("error", e))
			errch <- e
		} else {
			_Logger.Warn("HTTP server has been shutdown")
			errch <- nil
		}
	}()

	return errch, nil
}

func Shutdown() {
	var err error

	if _Server != nil {
		ctx, cancel := context.WithTimeout(context.TODO(), 5*time.Second)

		if err = _Server.Shutdown(ctx); err != nil {
			_Logger.Error("http server shutdown", zap.Any("error", err))
		}
		cancel()
	}

	if _RPC != nil {
		_RPC.Shutdown()
	}

	if _RuntimeInfo != nil {
		_RuntimeInfo.End()
	}

	if _CloseOtel != nil {
		if err = _CloseOtel(); err != nil {
			_Logger.Error("close otel", zap.Any("error", err))
		}
	}

	if settings.Logger != nil {
		_ = settings.Logger.Down()
	}

	return
}
