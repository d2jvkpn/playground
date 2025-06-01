#!/usr/bin/env python3
import os

from tasks import process_document

import yaml
from fastapi import FastAPI, UploadFile, BackgroundTasks, Query
from pydantic import BaseModel
from celery import Celery


class UploadResponse(BaseModel):
    task_id: str
    status: str = "processing"

####
with open(os.getenv('config', 'configs/local.yaml'), 'r') as f:
   config = yaml.safe_load(f)

celery = Celery('tasks', broker=config["redis"]["broker"], result_backend=config["redis"]["result_backend"])


app = FastAPI()

@app.post("/upload", response_model=UploadResponse)
async def upload_file(file: UploadFile, background_tasks: BackgroundTasks):
    # 保存原始文件
    file_path = f"./data/uploads/{file.filename}"
    with open(file_path, "wb") as f:
        f.write(await file.read())
    
    # 触发异步处理
    task = process_document.delay(file_path)
    return {"task_id": task.id, "status": "processing"}


@app.get("/task/{task_id}")
async def check_status1(task_id: str):
    result = celery.AsyncResult(task_id)

    if result.failed():
        return {"status": "failed", "error": str(result.result)}

    if result.successful():
        return {"status": "success", "result": result.result}

    return {"status": result.status}


@app.get("/task")
async def check_status2(task_id: str = Query(..., description="Celery task ID")):
    result = celery.AsyncResult(task_id)

    if result.failed():
        return {"status": "failed", "error": str(result.result)}

    if result.successful():
        return {"status": "success", "result": result.result}

    return {"status": result.status}
