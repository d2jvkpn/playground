package api

import (
	// "fmt"
	"net/http"

	"demo-web/internal/settings"

	"github.com/gin-gonic/gin"
)

func LoadV1_Open(router *gin.RouterGroup, handlers ...gin.HandlerFunc) {
	open := router.Group("/api/v1/open", handlers...)

	open.GET("/hello", func(ctx *gin.Context) {
		ctx.JSON(http.StatusOK, gin.H{"code": 0, "msg": "ok", "data": gin.H{}})
	})

	open.GET("/world", func(ctx *gin.Context) {
		value := settings.ConfigField("hello").GetInt64("world")
		ctx.JSON(http.StatusOK, gin.H{
			"code": 0, "msg": "ok", "data": gin.H{"value": value},
		})
	})

	open.GET("/meta", func(ctx *gin.Context) {
		ctx.JSON(http.StatusOK, gin.H{
			"code": 0, "msg": "ok", "data": gin.H{"meta": settings.Meta},
		})
	})
}
