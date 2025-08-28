#!/usr/bin/env python3
from loguru import logger

# 基本使用
logger.debug("这是一条调试信息")
logger.bind(a=1).debug("这是一条调试信息")
logger.info("这是一条信息")
logger.warning("这是一条警告")
logger.error("这是一条错误")

# 配置
logger.add(
    "logs/file_{time}.log",
    rotation="500 MB",    # 文件大小达到500MB时轮转
    retention="10 days",  # 保留10天的日志
    compression="zip",    # 压缩旧日志
    level="DEBUG",
)

# 带上下文信息的日志
def process_data(data):
    logger.info("开始处理数据", extra={"data_size": len(data)})
    try:
        # 处理逻辑
        logger.success("数据处理成功")
    except Exception as e:
        logger.error("数据处理失败", exc_info=True)

# 异常处理
@logger.catch
def risky_function():
    return 1 / 0


