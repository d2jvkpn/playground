package api

import (
	"fmt"
	"net/http"

	ibiz "demo-api/internal/biz"
	"demo-api/internal/settings"

	"github.com/d2jvkpn/gotk"
	"github.com/d2jvkpn/gotk/ginx"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

func Load_OpenV1(router *gin.RouterGroup, handlers ...gin.HandlerFunc) {
	open := router.Group("/api/v1/open", handlers...)

	open.GET("/nts", gin.WrapF(gotk.NTSFunc(3)))

	open.GET("/meta", func(ctx *gin.Context) {
		ctx.JSON(http.StatusOK, gin.H{
			"code": 0, "msg": "ok", "data": gin.H{"meta": settings.Meta},
		})
	})

	//
	value := settings.ConfigField("hello").GetInt64("world")
	open.GET("/hello", func(ctx *gin.Context) {
		ctx.JSON(http.StatusOK, gin.H{
			"code": 0, "msg": "ok", "data": gin.H{
				"key": "world", "value": value, "ip": ctx.ClientIP()},
		})
	})
}

func Load_Debug(router *gin.RouterGroup, handlers ...gin.HandlerFunc) {
	router.GET("/prometheus", gin.WrapH(promhttp.Handler()))

	debug := router.Group("/debug", handlers...)

	kfs := gotk.PprofHandlerFuncs()

	for _, k := range gotk.PprofFuncKeys() {
		debug.GET(fmt.Sprintf("/pprof/%s", k), gin.WrapF(kfs[k]))
	}
}

func Load_Biz(router *gin.RouterGroup, handlers ...gin.HandlerFunc) {
	biz := router.Group("/api/v1/biz", handlers...)

	biz.GET("/error", func(ctx *gin.Context) {
		requestId := uuid.NewString()
		err := ibiz.BizError()

		ginx.SetRequestId(ctx, requestId)
		ginx.SetError(ctx, err)
		ginx.SetIdentity(ctx, map[string]string{"biz_id": "expected_0001", "ip": ctx.ClientIP()})
		ginx.SetData(ctx, map[string]any{"query": ctx.Request.URL.RawQuery})
		ginx.SetData(ctx, map[string]any{"ans": 42})

		ctx.JSON(http.StatusBadRequest, gin.H{
			"request_id": requestId, "code": -1, "msg": err.Error(), "data": gin.H{"ans": 42},
		})
	})

	biz.GET("/div_panic", func(ctx *gin.Context) {
		requestId := uuid.NewString()

		ginx.SetRequestId(ctx, requestId)
		ginx.SetIdentity(ctx, map[string]string{"biz_id": "div_panci"})
		ginx.SetData(ctx, map[string]any{"ans": 42})

		ctx.JSON(http.StatusOK, gin.H{
			"request_id": requestId, "code": 0, "msg": "ok", "data": gin.H{"ans": divPanic()},
		})
	})
}

func divPanic() int {
	a, b := 1, 0

	return a / b
}
