#!/usr/bin/env python3
import os, argparse
from datetime import datetime
from pathlib import Path

import dotenv
from huggingface_hub import snapshot_download #, login

parser = argparse.ArgumentParser(
    description="huggingface snapshot_download",
    formatter_class=argparse.ArgumentDefaultsHelpFormatter,
)

parser.add_argument("--env", help="environment file", default=Path("configs") / "local.env")
parser.add_argument("--repo_type", help="repository type, e.g. model, dataset, space")
parser.add_argument("--force_download", help="force download", action="store_true")

parser.add_argument(
    "--ignore_lfs", help='ignore lfs files: ["*.bin", "*.safetensors", "*.pt"]',
    action="store_true",
)

parser.add_argument("repo_ids", help="repository ids", nargs="*")

args = parser.parse_args()
print(f"==> args: {args}")

dotenv.load_dotenv(args.env)
#login(os.environ['HF_TOKEN'], add_to_git_credential=False)

os.makedirs("data/huggingface", exist_ok=True) # ~/.cache/huggingface
ignore_patterns = ["original/*"]
if args.ignore_lfs:
    ignore_patterns.extend(["*.bin", "*.safetensors", "*.pt"])

for repo_id in args.repo_ids:
    t0 = datetime.now().astimezone().strftime("%FT%T%:z")
    print(f"--> {t0} snapshot_download: {repo_id}")

    snapshot_download(
        repo_id=repo_id,
        repo_type=args.repo_type,
        ignore_patterns=ignore_patterns,
        force_download=args.force_download,
        #cache_dir="data/huggingface/hub",
        #allow_patterns=["*.json", "*.txt", "*.py"],
    )
