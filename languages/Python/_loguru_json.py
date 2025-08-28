#!/usr/bin/env python3
from loguru import logger
from pathlib import Path

LOG_DIR = Path("logs")
LOG_DIR.mkdir(exist_ok=True)

# 控制台：人类可读
logger.remove()
logger.add(
    sink=lambda msg: print(msg, end=""),  # 简单 stdout
    level="INFO",
    colorize=True,
    format="<green>{time:YYYY-MM-DD HH:mm:ss}</green> | "
           "<level>{level: <7}</level> | "
           "{name}:{function}:{line} - <level>{message}</level>",
)

# 文件：JSON（每行一条），支持切分、保留、压缩
logger.add(
    LOG_DIR / "_loguru_json_v3.log",
    level="INFO",
    serialize=True,              # 关键：JSON
    rotation="00:00",            # 每天 0 点切分；可用 "100 MB" / "1 week" / datetime / callable
    retention="14 days",         # 只保留 14 天；也可用整数代表“保留 N 个文件”
    compression="zip",           # 过期文件压缩为 .zip；也可用 "gz"/"bz2"/"xz"
    enqueue=True,                # 跨进程/线程安全（异步队列）
    backtrace=True,              # 更友好的 traceback
    diagnose=True,               # 异常时输出变量值
)


logger.info("启动程序")
logger.warning("这是一个警告")
logger.error("出错了！")
logger.bind(user="alice", action="login").info("用户登录成功")
logger.bind(user="bob", action="delete", resource="file.txt").warning("用户删除了文件")
