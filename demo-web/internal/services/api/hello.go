package api

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func hello(ctx *gin.Context) {
	ctx.JSON(http.StatusOK, gin.H{"code": 0, "msg": "ok", "data": gin.H{}})
}
