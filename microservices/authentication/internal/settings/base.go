package settings

import (
	// "fmt"
	"math/rand"
	"time"

	"github.com/d2jvkpn/gotk/cloud-logging"
	"github.com/spf13/viper"
)

const (
	App = "authentication"
)

var (
	Release bool
	Logger  *logging.Logger
	Rng     *rand.Rand
	Config  *viper.Viper
)

func init() {
	Rng = rand.New(rand.NewSource(time.Now().UnixNano()))
}
