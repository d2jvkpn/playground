#!/usr/bin/env python3
import os, json
if __name__ != "__main__":
    os.environ["APP_ARGS"] = os.getenv("APP_ARGS", "--config=configs/local.yaml")

from gradio_app import webui

import yaml
import gradio as gr
from fastapi import FastAPI, Response # Request
from starlette.middleware.sessions import SessionMiddleware
from fastapi.middleware.cors import CORSMiddleware


#### 1. app
with open("project.yaml") as f:
    project = yaml.safe_load(f)

app = FastAPI()
app.add_middleware(SessionMiddleware, secret_key="xxxxxxxx")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

#### 2. routes
meta_response = Response(
    content=json.dumps(
         {"name": project['name'], "version": project['version']},
         ensure_ascii=False
    ) + "\n",
    media_type="application/json", headers={},
)
@app.get("/meta")
def meta():
    return meta_response


healthz_response = Response(
   content=json.dumps({"status": "ok"}, ensure_ascii=False) + "\n",
   media_type="application/json", headers={},
)
@app.get("/healthz")
def healthz():
     #return Response(content="ok\n", media_type="text/plain", headers={})
     return healthz_response


app = gr.mount_gradio_app(
    app,
    webui,
    path="",

    enable_monitoring=True,
    root_path="",
    allowed_paths=None,
    auth=None, # [("admin", "Admin123")]
    auth_message="Welcome to Gradio App",
    max_file_size=None,
)
