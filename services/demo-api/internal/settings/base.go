package settings

import (
	"bytes"
	// "fmt"
	"math/rand"
	"os"
	"time"

	"github.com/d2jvkpn/gotk"
	"github.com/d2jvkpn/gotk/cloud-logging"
	"github.com/spf13/viper"
)

var (
	_Project *viper.Viper
	_Config  *viper.Viper
	Lifetime <-chan time.Time
	Meta     map[string]any
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

	Meta["k8s"] = map[string]string{
		"namespace": os.Getenv("K8S_Namespace"),
		"node_name": os.Getenv("K8S_NodeName"),
		"pod_name":  os.Getenv("K8S_PodName"),
		"pod_ip":    os.Getenv("K8S_PodIP"),
	}

	return nil
}

func ProjectString(key string) string {
	return _Project.GetString(key)
}

func ProjectField(key string) *viper.Viper {
	return _Project.Sub(key)
}

// #### config
func SetConfig(config string) (err error) {
	_Config = viper.New()
	_Config.SetConfigType("yaml")
	_Config.SetConfigFile(config)

	if err = _Config.ReadInConfig(); err != nil {
		return err
	}

	//
	/*
		if !_Config.IsSet("lifetime") {
			return fmt.Errorf("lifetime is unset")
		}
	*/

	_Config.SetDefault("lifetime", "0m")
	lifetime := _Config.GetDuration("lifetime")
	Meta["lifetime-v0"] = lifetime.String()

	if lifetime > 0 {
		if lifetime < 15*time.Minute {
			lifetime = 15 * time.Minute
		}

		random := rand.New(rand.NewSource(time.Now().UnixNano()))
		lifetime = lifetime + time.Duration(random.Int63n(10*60)-5*60)*time.Second
		Lifetime = time.After(lifetime)
	}
	Meta["lifetime-v1"] = lifetime.String()

	// _Config.SetDefault("hello.world", 42)

	return nil
}

func ConfigString(key string) string {
	return _Config.GetString(key)
}

func ConfigField(key string) *viper.Viper {
	return _Config.Sub(key)
}
