#!/usr/bin/env python3
from pathlib import Path

from dotenv import load_dotenv


load_dotenv(dotenv_path=Path("configs") / "local.env")

api_key = os.getenv("API_KEY")
