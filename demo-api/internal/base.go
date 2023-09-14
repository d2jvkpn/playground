package internal

import (
	// "fmt"
	"embed"
	"net/http"
	"time"

	"github.com/d2jvkpn/gotk"
	"go.uber.org/zap"
)

const (
	HTTP_MaxHeaderBytes     = 2 << 11 // 4K
	HTTP_ReadHeaderTimeout  = 2 * time.Second
	HTTP_ReadTimeout        = 10 * time.Second
	HTTP_WriteTimeout       = 10 * time.Second
	HTTP_IdleTimeout        = 60
	HTTP_MaxMultipartMemory = 8 << 20 // 8M

	SHUTDOWN = "SHUTDOWN"
)

var (
	_Relase bool

	//go:embed static
	_Static embed.FS

	//go:embed templates
	_Templates embed.FS

	_Server *http.Server

	_Logger *zap.Logger

	_RuntimeInfo *gotk.RuntimeInfo
)
