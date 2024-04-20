package main

import (
	_ "embed"
	"errors"
	"flag"
	"fmt"
	"log/slog"
	"os"
	"os/signal"
	"syscall"
	"time"

	"demo-api/internal"
	"demo-api/internal/settings"

	"github.com/d2jvkpn/gotk"
)

//go:generate go fmt ./...
//go:generate go vet ./...
//go:generate echo -e >>> both "go fmt" and "go vet" are ok
//go:generate bash ./deployment/go_build.sh

var (
	//go:embed project.yaml
	_Project []byte
)

func main() {
	var (
		release     bool
		http_addr   string
		rpc_addr    string
		config      string
		config_path string

		err    error
		errch  chan error
		quit   chan os.Signal
		logger *slog.Logger
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

	flag.StringVar(
		&config, "config", "",
		"configuration file(yaml) path, default: load from project.yaml::config",
	) // configs/local.yaml

	flag.StringVar(&http_addr, "http.addr", "0.0.0.0:5031", "http listening address")
	flag.StringVar(&settings.HTTP_Path, "http.path", "", "http prefix path")
	flag.StringVar(&rpc_addr, "rpc.addr", "0.0.0.0:5041", "rpc listening address")

	flag.Usage = func() {
		output := flag.CommandLine.Output()

		fmt.Fprintf(output, "# %s\n\n", settings.ProjectString("app"))

		fmt.Fprintf(output, "#### usage\n```text\n")
		flag.PrintDefaults()
		fmt.Fprintf(output, "```\n")

		fmt.Fprintf(
			output,
			"\n#### configuration\n```yaml\n%s```\n",
			settings.ProjectString("config"),
		)

		fmt.Fprintf(output, "\n#### build\n```text\n%s\n```\n", gotk.BuildInfoText(settings.Meta))
	}

	flag.Parse()

	if config_path = config; config == "" {
		config = settings.ProjectString("config")
		config_path = "project.yaml::config"
	}

	if err = internal.Load(config, release); err != nil {
		logger.Error("load", "error", err)
		return
	}

	settings.Meta["config"] = config_path
	settings.Meta["http_address"] = http_addr
	settings.Meta["http_path"] = settings.HTTP_Path
	settings.Meta["rpc_address"] = rpc_addr
	settings.Meta["release"] = release
	settings.Meta["startup_time"] = time.Now().Format(time.RFC3339Nano)

	// logger.Info("Hello", "world", 42, "key", "value")
	if errch, err = internal.Run(http_addr, rpc_addr); err != nil {
		logger.Error("run", "error", err)
		return
	}

	logger.Info(
		"sevice is up",
		"config", config_path,
		"http_address", http_addr,
		"rpc_address", rpc_addr,
		"release", release,
		"lifetime", settings.Meta["lifetime"],
		"version", settings.Meta["version"],
	)

	quit = make(chan os.Signal, 1)
	signal.Notify(quit, os.Interrupt, syscall.SIGTERM) // syscall.SIGUSR2

	syncErrors := func(num int) {
		for i := 0; i < num; i++ {
			err = errors.Join(err, <-errch)
		}
	}

	select {
	case err = <-errch:
		syncErrors(cap(errch) - 1)

		logger.Error("... received from error channel", "error", err)
	case <-settings.Lifetime:
		errch <- fmt.Errorf(internal.MSG_EndOfLife)
		syncErrors(cap(errch))

		logger.Info("... end of life", "error", err)
	case sig := <-quit:
		// if sig == syscall.SIGUSR2 {...}
		// fmt.Fprintf(os.Stderr, "... received signal: %s\n", sig)
		errch <- fmt.Errorf(internal.MSG_Shutdown)
		syncErrors(cap(errch))

		logger.Info("... quit", "signal", sig.String(), "error", err)
	}
}
