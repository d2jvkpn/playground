#!/usr/bin/env python3
import os, time, logging

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


@task_failure.connect
def handle_task_failure(sender=None, task_id=None, exception=None, args=None, **kwargs):
    print(f"💣 Task {sender.name}({task_id}) failed: {exception} with args: {args}")


@app.task(bind=True)
def process_document(self, file_path: str):
    try:
        logger.info(f"📄 Processing file: {file_path}")
        if "network" in file_path:
            raise TransientNetworkError("🌐 Simulated network error")

        if "invalid" in file_path:
            raise ValueError("❌ Irrecoverable format error")

        size_bytes = os.path.getsize(file_path)
        time.sleep(10)
        print("✅ Done.")
        return {"status": "completed", "size_bytes": size_bytes }

    except TransientNetworkError as e:
        logger.error(f"⚠️ Transient error: {e}, retrying...")
        raise self.retry(exc=e)

    except Exception as e:
        logger.exception(f"❌ Fatal error: {e}")
        raise e  # don't auto retry
