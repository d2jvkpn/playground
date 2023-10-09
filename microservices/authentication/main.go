package main

import (
	_ "embed"
	"flag"
	"fmt"
	"log"
	"os"
	"os/signal"
	"path/filepath"
	"syscall"

	"authentication/internal"

	"github.com/d2jvkpn/gotk"
	"github.com/spf13/viper"
)

var (
	//go:embed project.yaml
	_Project []byte
)

func init() {
	gotk.RegisterLogPrinter()
}

func main() {
	var (
		release      bool
		addr, config string
		// consul       string
		err     error
		project *viper.Viper
	)

	if project, err = gotk.LoadYamlBytes(_Project); err != nil {
		log.Fatalln(err)
	}
	meta := gotk.BuildInfo()
	meta["app"] = project.GetString("app")
	meta["version"] = project.GetString("version")

	flag.StringVar(&addr, "addr", ":20001", "grpc listening address")
	flag.StringVar(&config, "config", "configs/local.yaml", "configuration path")
	/*
		flag.StringVar(
			&consul, "consul", "",
			"consul config path, set -config to empty if you needs to read config from consul",
		)
	*/
	flag.BoolVar(&release, "release", false, "run in release mode")

	flag.Usage = func() {
		output := flag.CommandLine.Output()

		fmt.Fprintf(
			output, "%s\n\nUsage of %s:\n",
			gotk.BuildInfoText(meta), filepath.Base(os.Args[0]),
		)

		flag.PrintDefaults()

		fmt.Fprintf(
			output,
			"\nConfig template(configs/local.yaml):\n```yaml\n%s```\n",
			project.GetString("config"),
		)

		/*
			fmt.Fprintf(
				output,
				"\nConsul template(configs/consul.yaml):\n```yaml\n%s```\n",
				wrap.ConsulConfigDemo(),
			)
		*/
	}
	flag.Parse()

	meta["config"] = config
	meta["addr"] = addr
	meta["release"] = release
	meta["pid"] = os.Getpid()

	if err = internal.Load(config, release); err != nil {
		log.Fatalln(err)
	}

	errch, quit := make(chan error, 1), make(chan os.Signal, 1)

	log.Printf(">>> Greet RPC server: %q\n", addr)
	if err = internal.ServeAsync(addr, meta, errch); err != nil {
		internal.Shutdown()
		log.Fatalln(err)
	}

	signal.Notify(quit, os.Interrupt, syscall.SIGTERM)

	select {
	case err = <-errch:
	case <-quit:
		fmt.Println("")
		internal.Shutdown()
		err = <-errch
	}

	if err != nil {
		log.Fatalln(err)
	} else {
		log.Println("<<< Exit")
	}
}
