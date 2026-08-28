#!/usr/bin/env python3

import argparse
import sys

import requests
import yaml


CONFIG_EXAMPLE = """\
Config example:

```yaml
openai:
  base_url: https://api.openai.com/v1
  api_key: sk-xxxx
  schema: responses
  models:
  - gpt-5.4
  - gpt-5-mini

deepseek:
  base_url: https://api.deepseek.com/v1
  api_key: sk-xxxx
  schema: responses
  models:
  - deepseek-v4-flash
```

Usage:

  %(prog)s config.yaml openai
  %(prog)s config.yaml openai gpt-5-mini
  %(prog)s config.yaml --list
  %(prog)s config.yaml --all
"""


def load_config(path: str) -> dict:
    with open(path, "r", encoding="utf-8") as f:
        config = yaml.safe_load(f) or {}

    if not isinstance(config, dict):
        raise ValueError("Config root must be a mapping")

    return config


def get_provider(
    config: dict,
    provider_name: str,
    model_name: str | None = None,
):
    if provider_name not in config:
        raise ValueError(f"Unknown provider: {provider_name}")

    provider = config[provider_name]

    if not isinstance(provider, dict):
        raise ValueError(f"Provider '{provider_name}' must be a mapping")

    base_url = provider.get("base_url")
    api_key = provider.get("api_key")
    api = provider.get("schema", "chat")
    models = provider.get("models", [])

    if not base_url:
        raise ValueError(f"Provider '{provider_name}' has no base_url")

    if not api_key:
        raise ValueError(f"Provider '{provider_name}' has no api_key")

    if not models:
        raise ValueError(f"Provider '{provider_name}' has no models")

    if model_name is None:
        model_name = models[0]
    elif model_name not in models:
        raise ValueError(
            f"Model '{model_name}' is not configured for provider '{provider_name}'. "
            f"Available: {', '.join(models)}"
        )

    return {
        "provider": provider_name,
        "base_url": base_url.rstrip("/"),
        "api_key": api_key,
        "api": api,
        "model": model_name,
    }


def request_api(
    url: str,
    api_key: str,
    payload: dict,
):
    headers = {
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json",
    }

    print(f"POST: {url}")

    try:
        response = requests.post(url, headers=headers, json=payload, timeout=60)
    except requests.RequestException as e:
        print(f"❌ Request failed: {e}")
        return False

    print(f"HTTP: {response.status_code}")

    if not response.ok:
        print("❌ API error")
        print(response.text[:4000])
        return False

    try:
        data = response.json()
    except ValueError:
        print("❌ Invalid JSON response")
        print(response.text[:4000])
        return False

    print("✅ API available")
    print_output(data)

    return True


def print_output(data: dict):
    # /chat/completions
    choices = data.get("choices")

    if choices:
        try:
            print("Output:", choices[0]["message"]["content"])
            return
        except (KeyError, IndexError, TypeError):
            pass

    # /responses
    texts = []

    for item in data.get("output", []):
        for content in item.get("content", []):
            if content.get("type") == "output_text":
                texts.append(content.get("text", ""))

    if texts:
        print("Output:", "\n".join(texts))
        return

    print(data)


def test_provider(cfg: dict):
    print(f"Provider: {cfg['provider']}")
    print(f"Model:    {cfg['model']}")
    print(f"API:      {cfg['api']}")
    print(f"Base URL: {cfg['base_url']}")

    if cfg["api"] in (
        "chat",
        "chat_completions",
        "completions",
    ):
        return request_api(
            f"{cfg['base_url']}/chat/completions",
            cfg["api_key"],
            {
                "model": cfg["model"],
                "messages": [
                    { "role": "user", "content": "Reply with exactly: OK"}
                ],
                "max_tokens": 16,
            },
        )

    if cfg["api"] == "responses":
        return request_api(
            f"{cfg['base_url']}/responses",
            cfg["api_key"],
            { "model": cfg["model"], "input": "Reply with exactly: OK", "max_output_tokens": 16 },
        )

    raise ValueError(f"Unsupported API: {cfg['api']}")


def list_config(config: dict):
    for name, cfg in config.items():
        if not isinstance(cfg, dict):
            continue

        models = cfg.get("models", [])
        default_model = models[0] if models else "-"

        print(f"{name:16} api={cfg.get('api', 'chat'):10} default={default_model}")

        for model in models:
            print(f"  - {model}")


def main():
    parser = argparse.ArgumentParser(
        description="Test OpenAI-compatible API providers",
        epilog=CONFIG_EXAMPLE,
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )

    parser.add_argument("config", help="YAML config file")
    parser.add_argument("provider", nargs="?", help="Provider name")
    parser.add_argument("model", nargs="?", help="Model name; defaults to provider's first model")
    parser.add_argument("--list", action="store_true", help="List providers and models")
    parser.add_argument("--all", action="store_true", help="Test default model of every provider")

    args = parser.parse_args()

    try:
        config = load_config(args.config)

        if args.list:
            list_config(config)
            return

        if args.all:
            results = []

            for provider_name in config:
                print("\n" + "=" * 60)

                try:
                    cfg = get_provider(
                        config,
                        provider_name,
                    )
                    results.append(
                        test_provider(cfg)
                    )
                except Exception as e:
                    print(f"❌ {e}")
                    results.append(False)

            sys.exit(
                0 if results and all(results) else 1
            )

        if not args.provider:
            parser.error("provider is required unless --list or --all is used")

        cfg = get_provider(
            config,
            args.provider,
            args.model,
        )

        ok = test_provider(cfg)

        sys.exit(0 if ok else 1)

    except Exception as e:
        print(f"❌ Error: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
