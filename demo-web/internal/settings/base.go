package settings

import (
	"bytes"
	// "fmt"

	"github.com/d2jvkpn/gotk"
	"github.com/d2jvkpn/gotk/cloud-logging"
	"github.com/spf13/viper"
)

var (
	_Project *viper.Viper
	Meta     map[string]any
	Logger   *logging.Logger
)

func SetProject(bts []byte) (err error) {
	_Project = viper.New()
	_Project.SetConfigType("yaml")

	// _Project.ReadConfig(strings.NewReader(str))
	if err = _Project.ReadConfig(bytes.NewReader(bts)); err != nil {
		return err
	}

	Meta = gotk.BuildInfo()
	Meta["app"] = _Project.GetString("app")
	Meta["version"] = _Project.GetString("version")

	return nil
}

func ProjectString(key string) string {
	return _Project.GetString(key)
}
