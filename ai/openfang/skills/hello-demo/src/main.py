#!/usr/bin/env python3
"""
OpenFang demo skill: hello-demo

Protocol:
- OpenFang sends JSON to stdin:
  {
    "tool": "hello_user",
    "input": {"name": "Leonard", "language": "zh"}
  }

- Skill returns JSON to stdout:
  {
    "result": "你好，Leonard！这是 hello-demo skill 返回的结果。"
  }
"""

import json
import sys
from datetime import datetime, timezone


def hello_user(name: str, language: str = "zh") -> str:
    now = datetime.now(timezone.utc).isoformat()

    if language == "en":
        return (
            f"Hello, {name}! This response comes from the hello-demo "
            f"OpenFang skill. UTC time: {now}"
        )

    return f"你好，{name}！这是 hello-demo OpenFang skill 返回的结果。UTC 时间：{now}"


def add_numbers(a: float, b: float) -> str:
    result = a + b
    return f"{a} + {b} = {result}"


def main() -> None:
    try:
        raw = sys.stdin.read()
        payload = json.loads(raw)

        tool_name = payload.get("tool")
        input_data = payload.get("input", {})

        if tool_name == "hello_user":
            name = input_data["name"]
            language = input_data.get("language", "zh")
            result = hello_user(name=name, language=language)

        elif tool_name == "add_numbers":
            a = input_data["a"]
            b = input_data["b"]
            result = add_numbers(a=a, b=b)

        else:
            print(json.dumps(
                {"error": f"Unknown tool: {tool_name}"},
                ensure_ascii=False
            ))
            return

        print(json.dumps(
            {"result": result},
            ensure_ascii=False
        ))

    except Exception as exc:
        print(json.dumps(
            {"error": str(exc)},
            ensure_ascii=False
        ))


if __name__ == "__main__":
    main()
