#!/usr/bin/env python3
import os

from app.create_app import create_app

import yaml


with open(os.getenv('config', 'configs/local.yaml'), 'r') as f:
    config = yaml.safe_load(f)

app = create_app(config["http"])

if __name__ == "__main__":
    app.run()
