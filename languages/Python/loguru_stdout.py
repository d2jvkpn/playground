#!/usr/bin/env python3
import os, json

from loguru import logger


def json_stdout(message):
    record = message.record

    log_dict = {
        "logger": "loguru",
        "time": record["time"].strftime("%Y-%m-%dT%H:%M:%S%:z"),
        "level": record["level"].name,
        "trace": f"{record['file'].name}::{record['line']}::{record['function']}",
        "msg": record["message"],
        "extra": record["extra"],
    }

    print(json.dumps(log_dict, ensure_ascii=False), file=os.sys.stdout)

def init(level):
    logger.remove()

    logger.add(
        json_stdout,
        level=level,
        enqueue=True,
        backtrace=True,
        diagnose=True,
    )

if __name__ == '__main__':
    init("INFO")

    logger.info("启动程序")
    logger.warning("这是一个警告")
    logger.error("出错了！")
    logger.bind(user="alice", action="login").info("用户登录成功")
    logger.bind(user="bob", action="delete", resource="file.txt").warning("用户删除了文件")
