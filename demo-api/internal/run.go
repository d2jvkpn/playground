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
	"go.uber.org/zap"
)

func Run(addr string) (errch chan error, err error) {
	var (
		listener net.Listener
		once     *sync.Once
	)

	if listener, err = net.Listen("tcp", addr); err != nil {
		return nil, fmt.Errorf("net.Listen: %w", err)
	}

	_RuntimeInfo = gotk.NewRuntimeInfo(func(data map[string]string) {
		_Logger.Info("runtime", zap.Any("data", data))
	}, 60)
	_RuntimeInfo.Start()

	shutdown := func() {
		if _Server != nil {
			ctx, cancel := context.WithTimeout(context.TODO(), 5*time.Second)
			if err := _Server.Shutdown(ctx); err != nil {
				_Logger.Error(fmt.Sprintf("server shutdown: %v", err))
			}
			cancel()
		}

		once.Do(func() {
			err := onExit()
			if err == nil {
				_Logger.Warn("on_exit")
			} else {
				_Logger.Error("on_exit", zap.Any("error", err))
			}
		})
		return
	}

	errch = make(chan error, 2)
	once = new(sync.Once)

	_Logger.Info("service_start", zap.Any("meta", settings.Meta))
	go func() {
		if err := _Server.Serve(listener); err != http.ErrServerClosed {
			shutdown()
			errch <- err
		}
	}()

	go func() {
		if err := <-errch; err.Error() == SHUTDOWN {
			shutdown()
		}
		errch <- nil
	}()

	return errch, nil
}

func onExit() (err error) {
	_Logger.Info("service_shutdown")

	if _RuntimeInfo != nil {
		_RuntimeInfo.End()
	}

	if settings.Logger != nil {
		err = errors.Join(err, settings.Logger.Down())
	}

	return err
}
