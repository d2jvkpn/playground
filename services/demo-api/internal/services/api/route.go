package api

import (
	"fmt"
	"net/http"

	"demo-api/internal/biz"
	"demo-api/internal/settings"

	"github.com/d2jvkpn/gotk"
	"github.com/d2jvkpn/gotk/ginx"
	"github.com/d2jvkpn/gotk/impls"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

func Load_Public(router *gin.RouterGroup, handlers ...gin.HandlerFunc) {
	router.GET("/nts", gin.WrapF(impls.NTSFunc(3)))
	router.GET("/healthz", ginx.Healthz)
	router.GET("/prometheus", gin.WrapH(promhttp.Handler()))

	router.GET("/meta", func(ctx *gin.Context) {
		ctx.JSON(http.StatusOK, gin.H{"meta": settings.Meta})
	})

	debug := router.Group("/debug", handlers...)

	kfs := gotk.PprofHandlerFuncs()

	for _, k := range gotk.PprofFuncKeys() {
		debug.GET(fmt.Sprintf("/pprof/%s", k), gin.WrapF(kfs[k]))
	}
}

func Load_OpenV1(router *gin.RouterGroup, handlers ...gin.HandlerFunc) {
	open := router.Group("/api/v1/open", handlers...)

	//
	value := settings.ConfigField("hello").GetInt64("world")
	open.GET("/hello", func(ctx *gin.Context) {
		ctx.JSON(http.StatusOK, gin.H{
			"code": 0, "msg": "ok", "data": gin.H{
				"key": "world", "value": value, "ip": ctx.ClientIP()},
		})
	})
}

func Load_Biz(router *gin.RouterGroup, handlers ...gin.HandlerFunc) {
	bizRouter := router.Group("/api/v1/biz", handlers...)

	bizRouter.GET("/error", func(ctx *gin.Context) {
		requestId := uuid.NewString()
		err := biz.BizError()

		ginx.SetRequestId(ctx, requestId)
		ginx.SetError(ctx, err)
		ginx.SetIdentity(ctx, map[string]string{"biz_id": "expected_0001", "ip": ctx.ClientIP()})
		ginx.SetData(ctx, map[string]any{"query": ctx.Request.URL.RawQuery})
		ginx.SetData(ctx, map[string]any{"ans": 42})

		ctx.JSON(http.StatusBadRequest, gin.H{
			"request_id": requestId, "code": -1, "msg": err.Error(), "data": gin.H{"ans": 42},
		})
	})

	bizRouter.GET("/div_panic", func(ctx *gin.Context) {
		requestId := uuid.NewString()

		ginx.SetRequestId(ctx, requestId)
		ginx.SetIdentity(ctx, map[string]string{"biz_id": "div_panci"})
		ginx.SetData(ctx, map[string]any{"ans": 42})

		ctx.JSON(http.StatusOK, gin.H{
			"request_id": requestId, "code": 0, "msg": "ok", "data": gin.H{"ans": biz.DivPanic()},
		})
	})
}
