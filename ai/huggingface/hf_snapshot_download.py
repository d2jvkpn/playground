#!/usr/bin/env python3
import os, argparse
from pathlib import Path

#pip install dotenv huggingface_hub
import dotenv
from huggingface_hub import login, snapshot_download


parser = argparse.ArgumentParser(
    description="huggingface snapshot_download",
    formatter_class=argparse.ArgumentDefaultsHelpFormatter,
)

parser.add_argument(
    "--repo_id", help="repository id, e.g. Systran/faster-whisper-small",
    required=True,
)

parser.add_argument("--repo_type", help="repository type, e.g. model, dataset, space")

parser.add_argument("--login", help="login huggingface(env $HF_TOKEN)", action="store_true")
parser.add_argument("--cache_dir", help="cache directory", default=Path("data") / "huggingface")
parser.add_argument("--env", help="env filepath, e.g. configs/local.env", default=None)

args = parser.parse_args()

if env_filepath := args.env:
    print(f"==> load env: {env_filepath}")
    dotenv.load_dotenv(env_filepath, override=True)

if args.login:
    hf_token = os.getenv('HF_TOKEN')
    login(hf_token, add_to_git_credential=True)

os.makedirs(args.cache_dir, mode=511, exist_ok=True)

print(f"==> snapshot_download: {args.repo_id} to {args.cache_dir}")

snapshot_download(repo_id=args.repo_id, repo_type=args.repo_type, cache_dir=args.cache_dir)
