package internal

import (
	"crypto/tls"
	"fmt"
	"net/http"
	"path/filepath"

	"demo-api/internal/settings"

	"github.com/d2jvkpn/gotk/cloud-logging"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

func Load(config string, release bool) (err error) {
	var (
		engine *gin.Engine
		cert   tls.Certificate
	)

	if err = settings.SetConfig(config); err != nil {
		return err
	}
	_Relase = release

	// #### logging
	// _ = os.Setenv("APP_DebugMode", "false")
	log_file := filepath.Join("logs", settings.Project.GetString("app_name")+".log")
	if release {
		settings.Logger, err = logging.NewLogger(log_file, zap.InfoLevel, 1024)
	} else {
		settings.Logger, err = logging.NewLogger(log_file, zap.DebugLevel, 1024)
	}
	// settings.Logger.Logger = settings.Logger.Logger.With(
	// 	zap.String("version", settings.Project.GetString("version")),
	// )

	if err != nil {
		return err
	}

	_Logger = settings.Logger.Named("internal")

	// #### server
	if engine, err = newEngine(release); err != nil {
		return err
	}

	// TODO: set consts in base.go
	_Server = &http.Server{
		ReadTimeout:       HTTP_ReadTimeout,
		WriteTimeout:      HTTP_WriteTimeout,
		ReadHeaderTimeout: HTTP_ReadHeaderTimeout,
		MaxHeaderBytes:    HTTP_MaxHeaderBytes,
		// Addr:              addr,
		Handler: engine,
	}

	httpConfig := settings.Config.Sub("http")
	if httpConfig == nil {
		return fmt.Errorf("config.http is unset")
	}
	if httpConfig.GetBool("tls") {
		certFile, keyFile := httpConfig.GetString("cert"), httpConfig.GetString("key")

		if cert, err = tls.LoadX509KeyPair(certFile, keyFile); err != nil {
			return err
		}
		_Server.TLSConfig = &tls.Config{
			Certificates: []tls.Certificate{cert},
		}
	}

	//
	rpcConfig := settings.Config.Sub("rpc")
	if rpcConfig == nil {
		return fmt.Errorf("config.rpc is unset")
	}
	if _RPC, err = NewRPCServer(rpcConfig, settings.Logger.Named("rpc"), false); err != nil {
		return err
	}

	return nil
}
