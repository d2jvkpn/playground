package internal

import (
	"context"
	"errors"
	"fmt"
	"net"
	"net/http"
	"sync"
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

	opentel := settings.ConfigField("opentel")
	if opentel.GetBool("enable") {
		_CloseOtel, err = tracing.LoadOtelGrpc(
			opentel.GetString("address"),
			settings.ProjectString("app"),
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
		_InternalLogger.Info("runtime", zap.Any("data", data))
	}, 60)

	_RuntimeInfo.Start()

	_InternalLogger.Info("service_start", zap.Any("meta", settings.Meta))

	once := new(sync.Once)
	shutdown := func() { once.Do(_Shutdown) }
	errch = make(chan error, 2) // let the capacity of channel equals to number of services

	go func() {
		if err := _RPC.Serve(rpcListener); err != nil {
			shutdown()
		}
		errch <- fmt.Errorf("rpc_service_down")
	}()

	go func() {
		if err := _Server.Serve(httpListener); err != http.ErrServerClosed {
			shutdown()
		}
		errch <- fmt.Errorf("http_server_down")
	}()

	go func() {
		err := <-errch
		msg := err.Error()

		if msg == MSG_Shutdown || msg == MSG_EndOfLife {
			shutdown()
		} else {
			errch <- err // !!! send back
		}
	}()

	return errch, nil
}

func _Shutdown() {
	var err error

	if _Server != nil {
		ctx, cancel := context.WithTimeout(context.TODO(), 5*time.Second)
		err = _Server.Shutdown(ctx)
		cancel()
	}

	if _RPC != nil {
		_RPC.Shutdown()
	}

	_InternalLogger.Info("service_shutdown")

	if _RuntimeInfo != nil {
		_RuntimeInfo.End()
	}

	if _CloseOtel != nil {
		err = errors.Join(err, _CloseOtel())
	}

	if err == nil {
		_InternalLogger.Warn("shutdown")
	} else {
		_InternalLogger.Error("shutdown", zap.Any("error", err))
	}

	if settings.Logger != nil {
		_ = settings.Logger.Down()
	}

	return
}
