package settings

import (
	"bytes"
	// "fmt"

	"github.com/d2jvkpn/gotk"
	"github.com/d2jvkpn/gotk/cloud-logging"
	"github.com/spf13/viper"
)

var (
	Meta     map[string]any
	_Project *viper.Viper
	_Config  *viper.Viper
	Logger   *logging.Logger
)

// #### project
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
	Meta["k8s_pod"] = os.Getenv("K8S_Pod")
	Meta["k8s_node"] = os.Getenv("K8S_Node")

	return nil
}

func ProjectString(key string) string {
	return _Project.GetString(key)
}

// #### config
func SetConfig(config string) (err error) {
	_Config = viper.New()
	_Config.SetConfigType("yaml")
	_Config.SetConfigFile(config)

	if err = _Config.ReadInConfig(); err != nil {
		return err
	}

	// _Config.SetDefault("hello.world", 42)

	return nil
}

func ConfigField(key string) *viper.Viper {
	return _Config.Sub(key)
}
