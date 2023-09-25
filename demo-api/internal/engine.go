package internal

import (
	"fmt"
	"html/template"
	"io/fs"
	"net/http"
	// "time"

	"demo-api/internal/services/api"
	"demo-api/internal/settings"

	"github.com/d2jvkpn/gotk/cloud-metrics"
	"github.com/d2jvkpn/gotk/ginx"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

func newEngine(release bool) (engine *gin.Engine, err error) {
	var (
		fsys   fs.FS
		tmpl   *template.Template
		router *gin.RouterGroup
		prom   gin.HandlerFunc
	)

	if release {
		gin.SetMode(gin.ReleaseMode)
		engine = gin.New()
		// engi.Use(gin.Recovery())
	} else {
		engine = gin.Default()
	}
	engine.RedirectTrailingSlash = false
	engine.MaxMultipartMemory = HTTP_MaxMultipartMemory
	router = &engine.RouterGroup

	// ### templates
	// engine.LoadHTMLGlob("templates/*.tmpl")
	tmpl, err = template.ParseFS(_Templates, "templates/*.html") // "templates/*/*.html"
	if err != nil {
		return nil, err
	}
	engine.SetHTMLTemplate(tmpl)
	engine.Use(ginx.Cors("*"))

	// #### handlers
	lg := settings.Logger.Named("no_router")
	notRouterLogger := func(ctx *gin.Context) {
		lg.Warn(fmt.Sprintf("%s@%s", ctx.Request.Method, ctx.Request.URL.Path),
			zap.String("ip", ctx.ClientIP()),
			zap.String("query", ctx.Request.URL.RawQuery),
		)
	}

	engine.NoRoute(notRouterLogger, func(ctx *gin.Context) {
		// ctx.AbortWithStatus(http.StatusNotFound)
		// time.Sleep(time.Second)
		ctx.JSON(http.StatusNotFound, gin.H{
			"code": -1, "msg": "router not found", "data": gin.H{},
		})
	})

	// //go:embed static/assets/favicon.ico
	// var favicon embed.FS
	// rg.StaticFileFS("/favicon.ico", "static/assets/favicon.ico", http.FS(favicon))
	router.GET("/healthz", ginx.Healthz)

	// #### static
	if fsys, err = fs.Sub(_Static, "static"); err != nil {
		return nil, err
	}
	static := router.Group("/static", ginx.CacheControl(3600))
	static.StaticFS("/", http.FS(fsys))
	ginx.ServeStaticDir("/site", "./site", false)(router)

	// #### debug apis
	api.Load_Debug(router)

	// #### biz handlers
	api.Load_OpenV1(router, ginx.APILog(settings.Logger.Logger, "api_open", 5))

	if prom, err = metrics.PromMetrics("http", "api"); err != nil {
		return nil, err
	}
	api.Load_Biz(
		router,
		ginx.APILog(settings.Logger.Logger, "api_biz", 5),
		prom,
	)

	return engine, nil
}
