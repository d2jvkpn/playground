#!/usr/bin/env python3
import os, time, logging
from typing import List
from datetime import timedelta

import yaml
from celery import Celery
from celery.signals import task_failure


class TransientNetworkError(Exception):
    pass

with open(os.getenv('config', 'configs/local.yaml'), 'r') as f:
   config = yaml.safe_load(f)

logger = logging.getLogger(__name__)
#logging.basicConfig(level=logging.INFO)
app = Celery('tasks', broker=config["redis"]["broker"], result_backend=config["redis"]["result_backend"])
# app.config_from_object('celeryconfig')
app.conf.result_expires = timedelta(hours=1)
app.conf.task_track_started = True


@task_failure.connect
def handle_task_failure(sender=None, task_id=None, exception=None, args=None, **kwargs):
    print(f"!!! Task {sender.name}({task_id}) failed: {exception} with args: {args}") # 💣


@app.task(bind=True)
def process_document(self, filepaths: List[str]):
    try:
        logging.info(f"--> {self.request.id} Processing file(s): {filepaths}") # 📄
        #if "network" in file_path:
        #    raise TransientNetworkError("!!! Simulated network error") # 🌐

        #if "invalid" in filepaths:
        #    raise ValueError("!!! Irrecoverable format error") # ❌

        size_bytes = 0
        for p in filepaths:
            size_bytes += os.path.getsize(p)

        time.sleep(100)
        logging.info(f"<-- {self.request.id} Done.") # ✅
        return {"status": "completed", "count": len(filepaths), "size_bytes": size_bytes }

    except TransientNetworkError as e:
        logger.error(f"!!! Transient error: {e}, retrying...") # ⚠️
        raise self.retry(exc=e)

    except Exception as e:
        logger.exception(f"!!! Fatal error: {e}") # ❌
        raise e  # don't auto retry
