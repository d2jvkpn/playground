#!/usr/bin/env python3
import os

import requests


# Note: this is not thread-safe
_session = requests.Session()

_user_key, _app_token = None, None


def init(user_key: str, app_token: str):
    global _user_key, _app_token

    if not user_key.strip() or not app_token.strip():
        raise ValueError("invalid tokens")

    _user_key, _app_token = user_key, app_token


# parameters: title, message, url_title, url, device
def push_msg(parameters, user_key=None, app_token=None):
    user_key = user_key or _user_key
    app_token = app_token or _app_token

    if not user_key or not app_token:
        return { "status": "invalid", "msg": "invalid user_key or app_token" }

    if not parameters['title'] or not parameters['message']:
        return { "status": "invalid", "msg": "no title and message" }

    if parameters["url"] and not parameters["url_title"]:
        return { "status": "invalid", "msg": "no url title" }

    msg_url = None
    if parameters.get("url"):
        msg_url = (parameters["url_title"], parameters["url"])

    data = {
        "user": user_key,
        "token": app_token,
        "html": 1,
        "title": parameters['title'],
        "message": parameters['message'],
        # optional extras:
        # "url_title": "View details",
        # "url": "https://example.com",
        # "sound": "bike",
        # "priority": "1",     # -2..2 (see below)
    }

    if msg_url:
        data["url_title"] = msg_url[0]
        data["url"] = msg_url[1]

    if parameters['device'] != "all":
        data['device'] = parameters['device'] # target specific device

    attachment = None
    if fp := parameters.get('attachment'):
        attachment = os.path.basename(fp)
        ext = fp.rsplit(".", 1)[-1].lower()

        with open(fp, "rb") as f:
            response = _session.post(
                "https://api.pushover.net/1/messages.json",
                data=data,
                files={"attachment": (attachment, f, f"image/{ext}")},
                timeout=5,
            )
    else:
        response = _session.post("https://api.pushover.net/1/messages.json", data, timeout=5)

    data = response.json()
    data["status_code"]: response.status_code

    if response.status_code != 200:
        return { "status": "failed", "msg": "failed to request", "data": data }

    return { "status": "ok", "msg": "ok", "data": data }


if __name__ == "__main__":
    import argparse
    import yaml

    parser = argparse.ArgumentParser(
        description="",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )

    parser.add_argument("--config", help="config path", default="./configs/local.yaml")
    parser.add_argument("--title", help="title", required=True)
    parser.add_argument("--message", help="message", required=True)
    parser.add_argument("--url_title", help="url title")
    parser.add_argument("--url", help="url")
    parser.add_argument("--attachment", help="attachment path")

    args = parser.parse_args(args=None)
    #print(f"--> args: {args}")

    with open(args.config, 'r') as f:
        config = yaml.safe_load(f)

    init(config['pushover']['user_key'], config['pushover']['app_token'])

    parameters = {
        "title": args.title, "message": args.message,
        "device": config['pushover'].get('device'),
        "url_title": args.url_title, "url": args.url,
        "attachment": args.attachment,
   }

    result = push_msg(parameters)
    print(f"result: {result}")
