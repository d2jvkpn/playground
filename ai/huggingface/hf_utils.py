#!/usr/bin/env python3

#pip install huggingface_hub


# repo_id = "Systran/faster-whisper-small"

def download(repo_id, cache_dir="downloads"):
    from huggingface_hub import snapshot_download

    snapshot_download(repo_id=repo_id, cache_dir=cache_dir)
