package internal

import (
	"fmt"
	"html/template"
	"io/fs"
	"net/http"
	// "time"

	"demo-api/internal/route"
	"demo-api/internal/settings"

	"github.com/d2jvkpn/gotk"
	"github.com/d2jvkpn/gotk/cloud-metrics"
	"github.com/d2jvkpn/gotk/ginx"
	"github.com/d2jvkpn/gotk/impls"
	"github.com/gin-gonic/gin"
	"github.com/prometheus/client_golang/prometheus/promhttp"
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
	if p := settings.Config.Sub("http").GetString("path"); p != "" {
		*router = *(router.Group(p))
	}

	cors := settings.Config.Sub("http").GetString("cors")
	engine.Use(ginx.Cors(cors))

	// ### templates
	// engine.LoadHTMLGlob("templates/*.tmpl")
	tmpl, err = template.ParseFS(_Templates, "templates/*.html") // "templates/*/*.html"
	if err != nil {
		return nil, err
	}
	engine.SetHTMLTemplate(tmpl)

	if settings.Config.Sub("opentel").GetBool("enabled") {
		engine.Use(otelgin.Middleware(settings.Project.GetString("app_name")))
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

		ctx.JSON(http.StatusNotFound, gin.H{"code": -1, "msg": "route not found"})
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
	debug := router.Group("/debug")
	kfs := gotk.PprofHandlerFuncs()

	for _, k := range gotk.PprofFuncKeys() {
		debug.GET(fmt.Sprintf("/pprof/%s", k), gin.WrapF(kfs[k]))
	}

	// #### public
	router.GET("/nts", gin.WrapF(impls.NTSFunc(3)))
	router.GET("/healthz", ginx.Healthz)

	if p := settings.Config.Sub("promethues"); p.GetBool("enabled") {
		p.SetDefault("path", "/metrics")
		router.GET(p.GetString("path"), gin.WrapH(promhttp.Handler()))
	}

	if !release {
		router.GET("/meta", func(ctx *gin.Context) {
			ctx.JSON(http.StatusOK, gin.H{"meta": settings.Meta})
		})
	}

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
