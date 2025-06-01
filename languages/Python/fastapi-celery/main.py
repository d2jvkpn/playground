#!/usr/bin/env python3
import os, traceback

from tasks import process_document

import yaml
from fastapi import FastAPI, UploadFile, BackgroundTasks, Request, Query
from fastapi.responses import JSONResponse, PlainTextResponse
from fastapi.exceptions import RequestValidationError, HTTPException
from pydantic import BaseModel
from celery import Celery
import logging.config


class ApiResponse(BaseModel):
    code: str = "ok"
    msg: str | None = None
    data: dict | None = None

def api_ok(data):
    return { "code": "ok", "data": data }

def api_error(code, msg, data=None):
    if data is None:
        return { "code": cod, "ms": msg }
    else:
        return { "code": cod, "ms": msg, "data": data }

####
with open(os.getenv('config', 'configs/local.yaml'), 'r') as f:
   config = yaml.safe_load(f)

logger = logging.getLogger(__name__)
# logger.info("✅ Logging with RFC 3339 timestamps")
celery = Celery('tasks', broker=config["redis"]["broker"], result_backend=config["redis"]["result_backend"])


app = FastAPI()

@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    return JSONResponse(
        status_code=500,
        content={
            "code": "internal_error",
            "msg": "Sorry, an Internal Server Error occured",
            "data": {
                "detail": str(exc),
                "trace": traceback.format_exc(),  # optinal: debug for development
            },
        },
    )

@app.exception_handler(HTTPException)
async def http_exception_handler(request: Request, exc: HTTPException):
    return JSONResponse(
        status_code=exc.status_code,
        content={"code": "http_error", "msg": exc.detail},
    )

@app.exception_handler(RequestValidationError)
async def validation_exception_handler(request: Request, exc: RequestValidationError):
    return JSONResponse(
      status_code=422,
      content={"code": "validation_error", "msg": exc.errors()},
    )


@app.exception_handler(404)
async def not_found_handler(request: Request, exc):
    return JSONResponse(
        status_code=404,
        content={"code": "not_found", "msg": "api not exists"}
    )

@app.get("/")
async def echo():
    return JSONResponse(content={"app": "fastapi-celery", "version": "1.0.0"})

@app.get("/healthz",  response_class=PlainTextResponse)
async def health_check():
    # return Response(content="ok", media_type="text/plain")
    return "ok\n"

@app.get("/hello", response_model=ApiResponse)
def hello():
    return api_ok({"value": 42})

@app.post("/task/create", response_model=ApiResponse)
async def upload_file(file: UploadFile, background_tasks: BackgroundTasks):
    file_path = f"./data/uploads/{file.filename}"

    with open(file_path, "wb") as f:
        f.write(await file.read())

    task = process_document.delay(file_path) # trigger async process
    return api_ok({"task_id": task.id, "status": "processing"})


#@app.get("/task/{task_id}")
#async def check_status(task_id: str):
#    result = celery.AsyncResult(task_id)

#    if result.failed():
#        return {"status": "failed", "error": str(result.result)}

#    if result.successful():
#        return {"status": "success", "result": result.result}

#    return {"status": result.status}


@app.post("/task/run")
def run_task(filepath: str = Query(..., description="filepath to process")):
    task = process_document.delay(filepath)
    return api_ok({"task_id": task.id, "status": "processing"})


@app.get("/task/status")
async def get_task_status(task_id: str = Query(..., description="Celery task ID")):
    result = celery.AsyncResult(task_id)

    if result.failed():
        return api_error("task_failed", "task failed", {"status": "failed", "result": str(result.result)})

    if result.successful():
        return api_ok({"status": "success", "result": result.result})

    return api_ok({"status": result.status})
