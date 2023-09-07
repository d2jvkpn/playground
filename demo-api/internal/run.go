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
			_Logger.Error("on exit", zap.Any("error", err))
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

	if settings.Logger != nil {
		err = errors.Join(err, settings.Logger.Down())
	}

	return err
}
