package cmd

import (
	"fmt"
	"log"

	"github.com/d2jvkpn/pieces/pkg/go/misc"
	"github.com/spf13/cobra"
	"github.com/spf13/pflag"
)

func NewServerCmd(name string) (command *cobra.Command) {
	var (
		port int64
		ip   string
		fSet *pflag.FlagSet
	)

	command = &cobra.Command{
		Use:   name,
		Short: `ntp server`,
		Long:  `network time protocol server`,

		Run: func(cmd *cobra.Command, args []string) {
			if port <= 0 {
				log.Fatalln("not server port provided")
			}

			addr := fmt.Sprintf("%s:%d", ip, port)
			ser, err := misc.NewNetworkTimeServer(addr, 10)
			if err != nil {
				log.Fatalln(err)
			}

			log.Printf(">>> Network Time Server listening on: %q\n", addr)
			log.Fatalln(ser.Run())
		},
	}

	fSet = command.Flags()
	fSet.Int64Var(&port, "port", 8080, "http server port")
	fSet.StringVar(&ip, "ip", "", "http server ip")

	return command
}
