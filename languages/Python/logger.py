#!/usr/bin/env python3
import os, logging
from pathlib import Path
from datetime import datetime
from logging.handlers import TimedRotatingFileHandler


def simple_log(path, level): # logs/app.log, logging.DEBUG, logging.INFO
    def rfc3339(*args):
        #return datetime.now(pytz.utc).isoformat()
        return str(datetime.now().astimezone()).replace(' ', 'T')

    logging.basicConfig(
        level=level,
        format='%(asctime)s %(levelname)s: %(message)s',
        handlers=[logging.FileHandler(path), logging.StreamHandler()],
        datefmt=None,
    )

    logging.Formatter.formatTime = rfc3339
    os.makedirs(Path(path).parent(), exist_ok=True)

    #logging.debug("logging debug")
    #logging.info("logging info")


def daily_logger(path, level=logging.INFO, name=None, console=False): # logs/app.log, logging.DEBUG
    def rfc3339(*args):
        #return datetime.now(pytz.utc).isoformat()
        return str(datetime.now().astimezone()).replace(' ', 'T')

    logger = logging.getLogger(name)
    logger.setLevel(level)

    if name:
        fmt = '%(asctime)s - %(levelname)s - %(name)s - %(filename)s:%(lineno)d - %(message)s'
    else:
        fmt = '%(asctime)s - %(levelname)s - %(filename)s:%(lineno)d - %(message)s'

    formatter = logging.Formatter(fmt)
    formatter.formatTime = rfc3339

    ####
    os.makedirs(Path(path).parent, exist_ok=True)

    file_handler = TimedRotatingFileHandler(
        filename=path,
        when="midnight",
        interval=1,
        backupCount=30,
        encoding="utf-8",
        utc=False,
        delay=False,
    )
    #file_handler.suffix = "%Y-%m-%d"
    #file_handler.extMatch = r"\d{4}-\d{2}"
    file_handler.setFormatter(formatter)

    logger.addHandler(file_handler)

    ####
    if console:
        console_handler = logging.StreamHandler()
        console_handler.setFormatter(formatter)
        #console_handler.setLevel(level)

        logger.addHandler(console_handler)

    # logger = logging.getLogger("MonthlyLogger")
    # logger.info("an event has happened")
    return logger
