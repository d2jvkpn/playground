import os
import json
import base64
import mimetypes
import argparse

import requests

from load_config import from_yaml_file, AppConfig


def print_response(resp: requests.Response):
    print("HTTP", resp.status_code)
    try:
        data = resp.json()
        print(json.dumps(data, ensure_ascii=False, indent=2))
    except Exception:
        print(resp.text)

    print("")

def request(config: AppConfig, _input: str | list, agent: str = "", user: str = ""):
    agent = agent or config.openclaw.agent

    headers = {
        "Authorization": f"Bearer {config.openclaw.token}",
        "Content-Type": "application/json",
        "x-openclaw-agent-id": agent,
    }

    payload = {
        "user": user or config.openclaw.user,
        "model": f"openclaw/{agent}",
        "input": _input,
    }

    print(f"--> payload: {payload}")

    resp = requests.post(
        config.openclaw.url + "/v1/responses",
        headers=headers,
        json=payload,
        timeout=config.openclaw.timeout,
    )

    return resp

def build_file_content(file_path: str) -> dict:
    mime_type, _ = mimetypes.guess_type(file_path)
    if not mime_type:
        mime_type = "application/octet-stream"

    with open(file_path, "rb") as f:
        b64 = base64.b64encode(f.read()).decode("utf-8")

    _type, source = "", {}
    if mime_type.startswith("image/"):
        _type = "input_image"
        source = {"type": "base64", "media_type": mime_type, "data": b64}
    else:
        filename = os.path.basename(file_path)
        _type = "input_file",
        source = {"type": "base64", "media_type": mime_type, "data": b64, "filename": filename}

    return { "type": _type, "source": source }

def generate_input(image_url: str, file_path: str, prompt: str):
    content = []

    if image_url:
        content.append({"type": "input_image", "source": {"type": "url", "url": image_url}})

    if file_path:
        content.append(build_file_content(file_path))

    if prompt:
        content.append({"type": "input_text", "text": prompt})

    return [{"type": "message", "role": "user", "content": content}]


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="OpenClaw API test client")
    parser.add_argument("--config", default="configs/local.yaml", help="Path to YAML config file")
    parser.add_argument("--prompt", required=True, help="Text prompt")
    parser.add_argument("--image_url", default="", help="Image URL")
    parser.add_argument("--file_path", default="", help="Local file path (image or other)")
    args = parser.parse_args()

    config = from_yaml_file(args.config)

    if args.image_url or args.file_path:
        _input = generate_input(args.image_url, args.file_path, args.prompt)
        response = request(config, _input)
    else:
        response = request(config, args.prompt)

    print_response(response)
