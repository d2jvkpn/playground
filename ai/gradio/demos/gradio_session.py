#!/usr/bin/env python3

# import uvicorn
import gradio as gr
from fastapi import FastAPI, Request
from starlette.middleware.sessions import SessionMiddleware


app = FastAPI()
app.add_middleware(SessionMiddleware, secret_key="your-secret-key")


def is_logged_in(request: Request):
    return request.session.get("user") is not None

def greet(name):
    return f"Hello {name}!"


@app.get("/login")
def login(request: Request):
    request.session["user"] = "testuser"
    return {"status": "logged in"}


webui = gr.Interface(fn=greet, inputs="text", outputs="text")

app = gr.mount_gradio_app(
    app,
    webui,
    path="",

    enable_monitoring=True,
    server_name="127.0.0.1",
    server_port=7860,
    root_path=None,
    allowed_paths=None,
    auth=[("admin", "Admin123")],
    auth_message="Welcome to Gradio Demo",
    max_file_size="32mb",
)


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(
        description="LLM Assistant",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )

    parser.add_argument("--host", help="http listening host", default="127.0.0.1")
    parser.add_argument("--port", help="http listening port", type=int, default=7860)

    args = parser.parse_args()

    # import uvicorn
    # uvicorn.run(app, host=args.host, port=args.host, reload=False)
    webui.launch(
        share=False,
        debug=False,
        quiet=False,
        max_threads=16,

        enable_monitoring=True,
        server_name=args.host,
        server_port=args.port,
        root_path=None,
        allowed_paths=None,
        auth=[("admin", "Admin123")],
        auth_message="Welcome to Gradio Demo",
        max_file_size="32mb",

        #favicon_path="fav.ico",
        ssl_keyfile=None,
        ssl_certfile=None,
        ssl_keyfile_password=None,
        #ssr_mode=True,
    )

    # uvicorn.run(app, host="127.0.0.1", port=8000, reload=False)

#### dev
#uvicorn gradio_session:app --reload --host 0.0.0.0 --port 8000

#### production
#gunicorn gradio_session:app -k uvicorn.workers.UvicornWorker --workers 4 --bind 127.0.0.1:8000
