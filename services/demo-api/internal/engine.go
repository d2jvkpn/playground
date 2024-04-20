package internal

import (
	"fmt"
	"html/template"
	"io/fs"
	"net/http"
	// "time"

	"demo-api/internal/route"
	"demo-api/internal/settings"

	"github.com/d2jvkpn/gotk/cloud-metrics"
	"github.com/d2jvkpn/gotk/ginx"
	"github.com/gin-gonic/gin"
	"go.opentelemetry.io/contrib/instrumentation/github.com/gin-gonic/gin/otelgin"
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
	p := settings.ConfigField("http").GetString("path")
	*router = *(router.Group(p))

	// ### templates
	// engine.LoadHTMLGlob("templates/*.tmpl")
	tmpl, err = template.ParseFS(_Templates, "templates/*.html") // "templates/*/*.html"
	if err != nil {
		return nil, err
	}
	engine.SetHTMLTemplate(tmpl)

	cors := settings.ConfigField("http").GetString("cors")
	engine.Use(ginx.Cors(cors))

	if settings.ConfigField("opentel").GetBool("enable") {
		engine.Use(otelgin.Middleware(settings.ProjectString("app")))
	}

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
	// router.StaticFileFS("/favicon.ico", "static/assets/favicon.ico", http.FS(favicon))

	// #### static
	if fsys, err = fs.Sub(_Static, "static"); err != nil {
		return nil, err
	}
	static := router.Group("/static", ginx.CacheControl(3600))
	static.StaticFS("/", http.FS(fsys))
	ginx.ServeStaticDir("/site", "./site", false)(router)

	// route.LoadSite(router)

	LoadSwagger(router)

	// #### debug
	route.Load_Public(router)

	// #### biz handlers
	route.Load_OpenV1(router, ginx.APILog(settings.Logger.Logger, "api_open", 5))

	if prom, err = metrics.PromMetrics("http", "api"); err != nil {
		return nil, err
	}
	route.Load_Biz(
		router,
		ginx.APILog(settings.Logger.Logger, "api_biz", 5),
		prom,
	)

	// #### websocket handlers
	route.Load_Websocket(router)

	return engine, nil
}
