package main

import (
	"os"

	"ntp/cmd"

	"github.com/d2jvkpn/pieces/pkg/go/misc"
	"github.com/spf13/cobra"
)

const (
	_App = "ntp"
)

func init() {
	if os.Getenv("TZ") == "" {
		os.Setenv("TZ", "Asia/Shanghai")
	}

	os.Setenv("APP_Name", _App)
	misc.SetLogRFC3339()
}

func main() {
	rootCmd := &cobra.Command{Use: _App}

	rootCmd.AddCommand(cmd.NewServerCmd("server"))
	rootCmd.AddCommand(cmd.NewClientCmd("client"))

	rootCmd.Execute()
}
