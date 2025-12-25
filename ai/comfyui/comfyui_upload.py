#!/usr/bin/env python3
import os, mimetypes
from pathlib import Path

import yaml, requests

def upload_file(addr, fp):
    url = f"{addr}/upload/image"
    mime_type, _ = mimetypes.guess_type(fp)
    basename = Path(fp).name

    with open(fp, 'rb') as f:
        files = {
            'image': (fp, f, mime_type),
            'overwrite': (None, 'true'),
        }

        response = requests.post(url, files=files)

    response.raise_for_status()
    return response.json()

with open(str(Path("configs") / "local.yaml"), 'r', encoding='utf-8') as f:
    config = yaml.safe_load(f)

fp = os.sys.argv[1]

upload_file(config["address"], fp)
