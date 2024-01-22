package tests

import (
	"flag"
	"fmt"
	"os"
	"testing"
)

var (
	_CommandName string
	_CommandArgs []string
)

// go test -- --config=xxxx mycommand arg1 arg2
func TestMain(m *testing.M) {
	var (
		config string
		err    error
		tflag  *flag.FlagSet
	)

	tflag = flag.NewFlagSet("tests", flag.ExitOnError)
	flag.Parse() // must do

	tflag.StringVar(&config, "config", "../configs/local.yaml", "config filepath")

	tflag.Parse(flag.Args())
	fmt.Printf("~~~ config %s\n", config)

	defer func() {
		if err != nil {
			fmt.Printf("!!! TestMain: %v\n", err)
			os.Exit(1)
		}
	}()

	if len(tflag.Args()) > 0 {
		_CommandName = tflag.Args()[0]
	}
	_CommandArgs = tflag.Args()[1:]

	// TODO

	m.Run()
}

func TestClients(t *testing.T) {
	fmt.Printf(
		"~~~ Flags: %v, Command: %s, Args: %v\n",
		flag.Args(), _CommandName, _CommandArgs,
	)

	switch _CommandName {
	case "grpc":
		grpcClient(_CommandArgs)
	case "ws":
		wsClient(_CommandArgs)
	default:
		t.Fatalf("unkonw command: %s", _CommandName)
	}
}
