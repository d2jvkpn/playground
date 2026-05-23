#!/usr/bin/env python3

from __future__ import annotations

import html
import re
import shutil
from pathlib import Path


ROOT = Path(__file__).resolve().parent
CONFIG_PATH = ROOT / "configs" / "local.yaml"
TEMPLATE_PATH = ROOT / "index.html"
TARGET_DIR = ROOT / "target"
TARGET_HTML = TARGET_DIR / "template.html"
ASSETS_SRC = ROOT / "assets"
ASSETS_DST = TARGET_DIR / "assets"

PLACEHOLDER_RE = re.compile(r"{{\s*([a-zA-Z_][a-zA-Z0-9_]*)\s*}}")


def parse_simple_yaml(path: Path) -> dict[str, str]:
    data: dict[str, str] = {}
    for raw_line in path.read_text(encoding="utf-8").splitlines():
        line = raw_line.strip()
        if not line or line.startswith("#"):
            continue

        key, sep, value = raw_line.partition(":")
        if not sep:
            raise ValueError(f"invalid config line: {raw_line!r}")

        data[key.strip()] = value.strip().strip("'\"")

    return data


def render_template(template: str, context: dict[str, str]) -> str:
    def replace(match: re.Match[str]) -> str:
        key = match.group(1)
        if key not in context:
            raise KeyError(f"missing template variable: {key}")
        return html.escape(str(context[key]), quote=True)

    return PLACEHOLDER_RE.sub(replace, template)


def main() -> None:
    context = parse_simple_yaml(CONFIG_PATH)
    template = TEMPLATE_PATH.read_text(encoding="utf-8")

    TARGET_DIR.mkdir(exist_ok=True)
    TARGET_HTML.write_text(render_template(template, context), encoding="utf-8")

    if ASSETS_SRC.exists():
        shutil.copytree(ASSETS_SRC, ASSETS_DST, dirs_exist_ok=True)

    print(f"rendered {TARGET_HTML.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
