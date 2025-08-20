#!/usr/bin/env python3
import logging

#$ pip install python-json-logger
from pythonjsonlogger import jsonlogger


logger = logging.getLogger()

logHandler = logging.StreamHandler()
formatter = jsonlogger.JsonFormatter()

logHandler.setFormatter(formatter)
logger.addHandler(logHandler)
logger.setLevel(logging.INFO)

logger.info("account login successful!", extra={"user_id": 123, "role": "admin"})
