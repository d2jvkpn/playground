#!/usr/bin/env python3
import json

from loguru import logger


def init(filepath, level="INFO", rotation="512 MB", retention="32 days"):
    logger.add(
        filepath,
        format="{message}",
        serialize=True,
        enqueue=True,
        compression="zip",
        encoding="utf-8",
        rotation=rotation,
        retention=retention,
        level=level,
    )

if __name__ == '__main__':
    init("logs/loguru.log", level="INFO")

    # 使用bind来添加上下文字段（例如用户ID、功能模块、请求ID）
    ctx_logger = logger.bind(user_id="12345", feature="payment", request_id="req-67890")

    # 记录不同级别的日志，绑定的字段会自动包含在JSON输出中
    ctx_logger.debug("User selected payment method.")
    ctx_logger.info("Payment processing started.", extra_data={"amount": 99.99, "currency": "USD"})
    ctx_logger.warning("Payment took longer than expected.", delay_ms=2050)

    try:
        # 模拟一个可能出错的操作
        result = 10 / 0
    except Exception as e:
        ctx_logger.error("An error occurred during payment processing.", error=str(e))

    # 你也可以在需要时临时覆盖或添加新的绑定字段
    ctx_logger.bind(transaction_id="txn-abc123").success("Payment completed successfully.")
