package route

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func LoadSite(rg *gin.RouterGroup, handlers ...gin.HandlerFunc) {
	route := rg.Group("/site/", handlers...)

	route.GET("/not_found", notFound)
}

func notFound(ctx *gin.Context) {
	ctx.HTML(http.StatusNotFound, "page_not_found", nil)
}
