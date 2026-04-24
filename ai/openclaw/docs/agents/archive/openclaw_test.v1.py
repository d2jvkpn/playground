import os
import json
import base64
import mimetypes

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

def build_headers(config: AppConfig):
    return {
        "Authorization": f"Bearer {config.openclaw.token}",
        "Content-Type": "application/json",
        "x-openclaw-agent-id": config.openclaw.agent,
    }

#def ask_text(config: AppConfig, prompt: str, user: str | None = None):
def ask_text(config: AppConfig, prompt: str, user: str):
    payload = {
        "user": user,
        "model": f"openclaw/{config.openclaw.agent}",
        "input": prompt,
    }

    resp = requests.post(
        config.openclaw.url + "/v1/responses",
        headers=build_headers(config),
        json=payload,
        timeout=config.openclaw.timeout,
    )
    return resp


def ask_with_image_url(config: AppConfig, prompt: str, image_url: str, user: str):
    payload = {
      "user": user,
      "model": f"openclaw/{config.openclaw.agent}",
      "input": [
        {
          "type": "message",
          "role": "user",
          "content": [
            { "type": "input_text", "text": prompt },
            { "type": "input_image", "source": { "type": "url", "url": image_url } },
          ],
        }
      ],
    }

    resp = requests.post(
        config.openclaw.url + "/v1/responses",
        headers=build_headers(config),
        json=payload,
        timeout=config.openclaw.timeout,
    )

    return resp

def file_to_base64(path: str) -> tuple[str, str]:
    mime_type, _ = mimetypes.guess_type(path)
    if not mime_type:
        mime_type = "application/octet-stream"

    with open(path, "rb") as f:
        b64 = base64.b64encode(f.read()).decode("utf-8")

    return mime_type, b64

def ask_with_image_base64(config: AppConfig, prompt: str, image_path: str, user: str):
    mime_type, b64_data = file_to_base64(image_path)

    payload = {
      "user": user,
      "model": f"openclaw/{config.openclaw.agent}",
      "input": [
        {
          "type": "message",
          "role": "user",
          "content": [
            { "type": "input_text", "text": prompt },
            {
              "type": "input_image",
              "source": { "type": "base64", "media_type": mime_type, "data": b64_data },
            },
          ],
        }
      ],
    }

    resp = requests.post(
        config.openclaw.url + "/v1/responses",
        headers=build_headers(config),
        json=payload,
        timeout=config.openclaw.timeout,
    )
    return resp


if __name__ == "__main__":
    config = from_yaml_file("configs/local.yaml")

    # 1. 纯文本测试
    print("=== 1. 纯文本测试 ===")
    r = ask_text(config, "你好，请简单介绍自己。", user="user01")
    print_response(r)

    # 2. 图片 URL 测试
    print("=== 2. 图片 URL 测试 ===")
    image_url = "https://h5-202604.sh-aliyun.4dpoc.com/static/pictures/cat_and_otter.png"
    r = ask_with_image_url(config, "Describe this image.", image_url, user=config.openclaw.user)
    print_response(r)

    # 3. 本地图片 base64 测试
    print("=== 3. 本地图片 base64 测试 ===")
    local_image = "data/cat_and_otter.png"   # 改成你的本地图片路径
    if os.path.exists(local_image):
        r = ask_with_image_base64(config, "Describe this image.", local_image, user=config.openclaw.user)
        print_response(r)
    else:
        print(f"本地图片不存在，跳过: {local_image}")
