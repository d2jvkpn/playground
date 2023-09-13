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
			start  time.Time
			msg    string
			status int
		)

		start = time.Now()
		msg = fmt.Sprintf("%s@%s", ctx.Request.Method, ctx.Request.URL.Path)

		// #### TODO: defer data = recover()

		// #### logging
		fields := make([]zap.Field, 0, 3)
		pushStr := func(key, val string) {
			fields = append(fields, zap.String(key, val))
		}

		pushStr("ip", ctx.ClientIP())
		if ctx.Request.URL.RawQuery != "" {
			pushStr("query", ctx.Request.URL.RawQuery)
		}

		status = ctx.Writer.Status()
		latency := fmt.Sprintf("%.3fms", float64(time.Since(start).Microseconds())/1e3)
		pushStr("latency", latency)
		// TODO: more fields like identity and biz data

		switch {
		case status < 400:
			logger.Info(msg, fields...)
		case status >= 400 && status < 500:
			logger.Warn(msg, fields...)
		default:
			logger.Info(msg, fields...)
		}
	}
}
