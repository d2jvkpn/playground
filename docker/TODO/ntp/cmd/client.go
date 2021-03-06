package cmd

import (
	"fmt"
	"log"

	"github.com/d2jvkpn/pieces/pkg/go/misc"
	"github.com/spf13/cobra"
	"github.com/spf13/pflag"
)

func NewClientCmd(name string) (command *cobra.Command) {
	var (
		delay int64
		addr  string
		fSet  *pflag.FlagSet
	)

	command = &cobra.Command{
		Use:   name,
		Short: `ntp client`,
		Long:  `network time protocol client`,

		Run: func(cmd *cobra.Command, args []string) {
			var (
				err    error
				result *misc.NetworkTimeResult
			)

			if addr == "" {
				log.Fatalf("invalid addr: %q\n", addr)
			}

			if result, err = misc.GetNetworkTime(addr, delay); err != nil {
				log.Fatalln(err)
			}

			fmt.Println(result)
		},
	}

	fSet = command.Flags()
	fSet.StringVar(&addr, "addr", "", "request addres")
	fSet.Int64Var(&delay, "delay", 1000, "delay in millsec")

	return command
}
