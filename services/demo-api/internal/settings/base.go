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
	Project *viper.Viper
	Config  *viper.Viper

	HTTP_Path string
	Lifetime  <-chan time.Time
	Meta      map[string]any
	Logger    *logging.Logger
)

// #### project
func SetProject(bts []byte) (err error) {
	Project = viper.New()
	Project.SetConfigType("yaml")

	// _Project.ReadConfig(strings.NewReader(str))
	if err = Project.ReadConfig(bytes.NewReader(bts)); err != nil {
		return err
	}

	Meta = gotk.BuildInfo()
	Meta["app_name"] = Project.GetString("app_name")
	Meta["version"] = Project.GetString("version")

	Meta["k8s"] = map[string]string{
		"namespace": os.Getenv("K8S_Namespace"),
		"node_name": os.Getenv("K8S_NodeName"),
		"pod_name":  os.Getenv("K8S_PodName"),
		"pod_ip":    os.Getenv("K8S_PodIP"),
	}

	return nil
}

// #### config
func SetConfig(config string, release bool) (err error) {
	Config = viper.New()
	Config.SetConfigType("yaml")

	if config == "project.yaml::config" {
		err = Config.ReadConfig(bytes.NewReader([]byte(Project.GetString("config"))))
	} else {
		Config.SetConfigFile(config)
		err = Config.ReadInConfig()
	}

	if err != nil {
		return err
	}

	Config.Set("config", config)
	Config.Set("release", release)
	Meta["config"] = config
	Meta["release"] = release

	Config.SetDefault("lifetime", "0m")
	lifetime := Config.GetDuration("lifetime")
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

	// Config.SetDefault("hello.world", 42)

	return nil
}
