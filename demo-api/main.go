package main

import (
	_ "embed"
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

//go:generate bash ./scripts/go_build.sh

var (
	//go:embed project.yaml
	_Project []byte
)

func main() {
	var (
		release       bool
		addr, rpcAddr string
		config        string
		err           error
		logger        *slog.Logger
		errch         chan error
		quit          chan os.Signal
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

	flag.StringVar(&config, "config", "configs/local.yaml", "configuration file(yaml) path")
	flag.StringVar(&addr, "addr", "0.0.0.0:5031", "listening address")
	flag.BoolVar(&release, "release", false, "run in release mode")

	flag.Usage = func() {
		output := flag.CommandLine.Output()

		fmt.Fprintf(output, "Usage:\n")
		flag.PrintDefaults()

		fmt.Fprintf(
			output, "\nConfiguration:\n```yaml\n%s```\n",
			settings.ProjectString("config"),
		)
		fmt.Fprintf(output, "\nBuild:\n```text\n%s\n```\n", gotk.BuildInfoText(settings.Meta))
	}

	flag.Parse()

	if err = internal.Load(config, release); err != nil {
		logger.Error("load", "error", err)
		return
	}

	rpcAddr = settings.ConfigField("rpc").GetString("addr")
	settings.Meta["config"] = config
	settings.Meta["address"] = addr
	settings.Meta["rpc_address"] = rpcAddr
	settings.Meta["release"] = release
	settings.Meta["startup_time"] = time.Now().Format(time.RFC3339)

	// logger.Info("Hello", "world", 42, "key", "value")
	if errch, err = internal.Run(addr); err != nil {
		logger.Error("run", "error", err)
		return
	}

	logger.Info(
		"sevice is up",
		"adderss", addr,
		"rpc_address", rpcAddr,
		"config", config,
		"release", release,
	)

	quit = make(chan os.Signal, 1)
	// signal.Notify(quit, os.Interrupt, syscall.SIGTERM, syscall.SIGUSR2)
	signal.Notify(quit, os.Interrupt, syscall.SIGTERM)

	select {
	case err = <-errch:
		logger.Error("exit", "error", err)
	case sig := <-quit:
		// if sig == syscall.SIGUSR2 {...}
		fmt.Println("... received:", sig)
		errch <- fmt.Errorf(internal.SHUTDOWN)
		<-errch
		logger.Info("exit")
	}
}
