#!/usr/bin/env python3
from pathlib import Path

from pydantic import BaseModel, Field
import yaml


class OpenClawConfig(BaseModel):
    url: str = Field(alias="url")
    token: str = Field(alias="token", default="")
    timeout: int = Field(alias="timeout", default=120)
    agent: str = Field(alias="agent", default="main")
    user: str = Field(alias="user", default="user-01")

class AppConfig(BaseModel):
    """Application config. Example YAML (configs/local.yaml):

    .. code-block:: yaml

        openclaw:
          url: http://127.0.0.1:18789
          token: your-token-here
          timeout: 120
          agent: main
          user: user-01
    """
    openclaw: OpenClawConfig

def from_yaml_file(p: str | Path) -> AppConfig:
    with open(p, "r", encoding="utf-8") as f:
        data = yaml.safe_load(f)

    config = AppConfig.model_validate(data)
    return config

if __name__ == "__main__":
    config = from_yaml_file("configs/local.yaml")

    print(config)
    print(config.openclaw.url)
    print(config.openclaw.token)
    print(config.openclaw.timeout)

    print(config.openclaw.agent)
    print(config.openclaw.user)
