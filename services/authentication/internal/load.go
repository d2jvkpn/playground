package internal

import (
	"fmt"

	"authentication/internal/settings"

	"github.com/d2jvkpn/gotk"
)

func Load(config string, release bool) (err error) {
	settings.Release = release

	if config == "" {
		return fmt.Errorf("config is empty")
	}

	if settings.Config, err = gotk.LoadYamlConfig(config, "project"); err != nil {
		return err
	}

	return nil
}
