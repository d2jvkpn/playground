package api

import (
	"fmt"
	"net/http"

	"demo-api/internal/settings"

	"github.com/d2jvkpn/gotk"
	"github.com/gin-gonic/gin"
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
	debug := router.Group("/debug", handlers...)

	for k, f := range gotk.PprofHandlerFuncs() {
		debug.GET(fmt.Sprintf("/pprof/%s", k), gin.WrapF(f))
	}
}
