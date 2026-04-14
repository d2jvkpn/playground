#!/usr/bin/env python3
from __future__ import annotations

import asyncio
import json
import time
from typing import AsyncGenerator

from fastapi import FastAPI, Request
from fastapi.responses import StreamingResponse, HTMLResponse

app = FastAPI()


def sse_format(data: dict | str, event: str | None = None, event_id: str | None = None) -> str:
    """
    将数据格式化为 SSE 协议文本。
    SSE 每条消息以空行结束。
    """
    if isinstance(data, dict):
        payload = json.dumps(data, ensure_ascii=False)
    else:
        payload = data

    lines = []
    if event_id is not None:
        lines.append(f"id: {event_id}")
    if event is not None:
        lines.append(f"event: {event}")

    # SSE 规范里 data 可以有多行，每行前面都要加 data:
    for line in payload.splitlines() or [""]:
        lines.append(f"data: {line}")

    return "\n".join(lines) + "\n\n"


async def event_generator(request: Request) -> AsyncGenerator[str, None]:
    """
    持续生成 SSE 消息。
    如果客户端断开，则停止生成。
    """
    steps = [
        {"step": "planning", "message": "正在规划任务"},
        {"step": "searching", "message": "正在检索资料"},
        {"step": "tool_call", "message": "正在调用外部工具"},
        {"step": "summarizing", "message": "正在总结结果"},
        {"step": "done", "message": "处理完成"},
    ]

    # 先发一条连接成功消息
    yield sse_format(
        {"message": "SSE connected", "ts": int(time.time())},
        event="connected",
        event_id="0",
    )

    for idx, item in enumerate(steps, start=1):
        if await request.is_disconnected():
            print("客户端已断开连接")
            break

        yield sse_format(
            {
                "index": idx,
                "step": item["step"],
                "message": item["message"],
                "ts": int(time.time()),
            },
            event="status",
            event_id=str(idx),
        )

        await asyncio.sleep(1)

    # 结束前可发一条 done 事件
    if not await request.is_disconnected():
        yield sse_format(
            {"message": "stream finished", "ts": int(time.time())},
            event="done",
            event_id="9999",
        )


@app.get("/events")
async def sse_endpoint(request: Request) -> StreamingResponse:
    """
    SSE 端点。
    """
    headers = {
        "Cache-Control": "no-cache",
        "Connection": "keep-alive",
        # 反向代理如 Nginx 时很有用，避免缓冲
        "X-Accel-Buffering": "no",
    }
    return StreamingResponse(
        event_generator(request),
        media_type="text/event-stream",
        headers=headers,
    )


@app.get("/")
async def index() -> HTMLResponse:
    """
    一个最简单的测试页面。
    """
    html = """
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8" />
  <title>Python SSE Demo</title>
  <style>
    body { font-family: sans-serif; padding: 24px; }
    #log { white-space: pre-wrap; border: 1px solid #ccc; padding: 12px; min-height: 240px; }
    button { margin-right: 8px; }
  </style>
</head>
<body>
  <h1>Python SSE Demo</h1>
  <button id="connect">连接</button>
  <button id="close">关闭</button>
  <div id="log"></div>

  <script>
    let es = null;
    const log = document.getElementById("log");

    function append(text) {
      log.textContent += text + "\\n";
    }

    document.getElementById("connect").onclick = () => {
      if (es) {
        append("已经连接过了");
        return;
      }

      es = new EventSource("/events");

      es.onopen = () => append("[open] 连接已建立");

      es.onmessage = (e) => {
        append("[message] " + e.data);
      };

      es.addEventListener("connected", (e) => {
        append("[connected] " + e.data);
      });

      es.addEventListener("status", (e) => {
        append("[status] " + e.data);
      });

      es.addEventListener("done", (e) => {
        append("[done] " + e.data);
        es.close();
        es = null;
      });

      es.onerror = (e) => {
        append("[error] 连接异常或已关闭");
      };
    };

    document.getElementById("close").onclick = () => {
      if (es) {
        es.close();
        es = null;
        append("[close] 已手动关闭");
      }
    };
  </script>
</body>
</html>
    """
    return HTMLResponse(html)
