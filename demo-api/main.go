package main

import (
	_ "embed"
	"flag"
	"fmt"
	"log/slog"
	"os"
	"os/signal"
	"strings"
	"syscall"
	"time"

	"demo-api/internal"
	"demo-api/internal/settings"

	"github.com/d2jvkpn/gotk"
)

//go:generate bash ./scripts/go_build.sh

var (
	//go:embed project.yaml
	_Project []byte
)

func main() {
	var (
		release  bool
		httpAddr string
		rpcAddr  string
		config   string
		err      error
		logger   *slog.Logger
		errch    chan error
		quit     chan os.Signal
	)

	// logger = slog.New(slog.NewTextHandler(os.Stderr, nil))
	logger = slog.New(slog.NewJSONHandler(os.Stderr, nil))

	defer func() {
		if err != nil {
			os.Exit(1)
		}
	}()

	if err = settings.SetProject(_Project); err != nil {
		logger.Error("set project", "error", err)
		return
	}

	flag.BoolVar(&release, "release", false, "run in release mode")
	flag.StringVar(&config, "config", "configs/local.yaml", "configuration file(yaml) path")
	flag.StringVar(&httpAddr, "http_addr", "0.0.0.0:5031", "http listening address")
	flag.StringVar(&rpcAddr, "rpc_addr", "0.0.0.0:5041", "rpc listening address")

	flag.Usage = func() {
		output := flag.CommandLine.Output()

		fmt.Fprintf(output, "# %s\n\n", settings.ProjectString("app"))

		fmt.Fprintf(output, "#### usage\n```text\n")
		flag.PrintDefaults()
		fmt.Fprintf(output, "```\n")

		fmt.Fprintf(
			output, "\n#### configuration\n```yaml\n%s```\n",
			strings.Replace(
				settings.ProjectString("config"), "\n#\n", "\n\n", -1,
			),
		)
		fmt.Fprintf(
			output,
			"\n#### build\n```text\n%s\n```\n",
			gotk.BuildInfoText(settings.Meta),
		)
	}

	flag.Parse()

	if err = internal.Load(config, release); err != nil {
		logger.Error("load", "error", err)
		return
	}

	settings.Meta["config"] = config
	settings.Meta["http_address"] = httpAddr
	settings.Meta["rpc_address"] = rpcAddr
	settings.Meta["release"] = release
	settings.Meta["startup_time"] = time.Now().Format(time.RFC3339)

	// logger.Info("Hello", "world", 42, "key", "value")
	if errch, err = internal.Run(httpAddr, rpcAddr); err != nil {
		logger.Error("run", "error", err)
		return
	}

	logger.Info(
		"sevice is up",
		"http_adderss", httpAddr,
		"rpc_address", rpcAddr,
		"config", config,
		"release", release,
	)

	quit = make(chan os.Signal, 1)
	// signal.Notify(quit, os.Interrupt, syscall.SIGTERM, syscall.SIGUSR2)
	signal.Notify(quit, os.Interrupt, syscall.SIGTERM)

	select {
	case err = <-errch:
		logger.Error("... received from errch", "error", err)
	case sig := <-quit:
		// if sig == syscall.SIGUSR2 {...}
		// fmt.Fprintf(os.Stderr, "... received signal: %s\n", sig)
		errch <- fmt.Errorf(internal.SHUTDOWN)
		<-errch
		logger.Info("... received signal", "signal", sig.String())
	}
}
