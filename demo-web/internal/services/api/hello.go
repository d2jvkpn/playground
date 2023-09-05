package api

import (
	"net/http"

	"demo-web/internal/settings"

	"github.com/gin-gonic/gin"
)

func hello(ctx *gin.Context) {
	ctx.JSON(http.StatusOK, gin.H{"code": 0, "msg": "ok", "data": gin.H{}})
}

func world(ctx *gin.Context) {
	value := settings.ConfigField("hello").GetInt64("world")
	ctx.JSON(http.StatusOK, gin.H{"code": 0, "msg": "ok", "data": gin.H{"value": value}})
}
