package settings

import (
	"fmt"
	"time"

	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

func ApiLogger(name string) gin.HandlerFunc {
	logger := Logger.Named(name)

	return func(ctx *gin.Context) {
		var (
			start      time.Time
			msg        string
			statusCode int
		)

		start = time.Now()
		msg = fmt.Sprintf("%s@%s", ctx.Request.Method, ctx.Request.URL.Path)

		// #### TODO: defer data = recover()

		// #### logging
		fields := make([]zap.Field, 0, 3)
		push := func(field zap.Field) {
			fields = append(fields, field)
		}

		push(zap.String("ip", ctx.ClientIP()))
		if ctx.Request.URL.RawQuery != "" {
			push(zap.String("query", ctx.Request.URL.RawQuery))
		}

		statusCode = ctx.Writer.Status()
		latency := fmt.Sprintf("%.3fs", float64(time.Since(start).Microseconds())/1e3)
		push(zap.String("latency", latency))
		// TODO: more fields like identity and biz data

		switch {
		case statusCode < 400:
			logger.Info(msg, fields...)
		case statusCode >= 400 && statusCode < 500:
			logger.Warn(msg, fields...)
		default:
			logger.Info(msg, fields...)
		}
	}
}
