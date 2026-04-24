#!/usr/bin/env python3
from dataclasses import dataclass

import yaml

@dataclass
class OpenClawConfig:
    url: str
    token: str
    agent: str
    user: str

@dataclass
class AppConfig:
    openclaw: OpenClawConfig

def load_config(path: str) -> AppConfig:
    with open(path, "r", encoding="utf-8") as f:
        data = yaml.safe_load(f)

    openclaw_data = data["openclaw"]

    openclaw_config = OpenClawConfig(
        url=openclaw_data["url"],
        token=openclaw_data["token"],
        agent=openclaw_data["agent"],
        user=openclaw_data["user"],
    )

    return AppConfig(openclaw=openclaw_config)

if __name__ == "__main__":
    config = load_config("configs/local.yaml")

    print(config)
    print(config.openclaw.url)
    print(config.openclaw.token)
    print(config.openclaw.agent)
    print(config.openclaw.user)
