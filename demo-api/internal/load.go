package internal

import (
	// "fmt"
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
	)

	if err = settings.SetConfig(config); err != nil {
		return err
	}
	_Relase = release

	// #### logging
	// _ = os.Setenv("APP_DebugMode", "false")
	log_file := filepath.Join("logs", settings.ProjectString("app")+".log")
	if release {
		settings.Logger, err = logging.NewLogger(log_file, zap.InfoLevel, 512)
	} else {
		settings.Logger, err = logging.NewLogger(log_file, zap.DebugLevel, 512)
	}
	settings.Logger.Logger = settings.Logger.Logger.With(
		zap.String("version", settings.ProjectString("version")),
	)
	_Logger = settings.Logger.Named("internal")

	if err != nil {
		return err
	}

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

	return nil
}
