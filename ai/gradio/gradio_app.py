#!/usr/bin/env python3
import os, argparse, shlex, shutil
from pathlib import Path
from datetime import datetime, UTC

import gradio as gr


#### 1.
parser = argparse.ArgumentParser(
    description="LLM Assistant",
    formatter_class=argparse.ArgumentDefaultsHelpFormatter,
)

parser.add_argument("--config", help="config path", default=Path("configs") / "local.yaml")
parser.add_argument("--env", help="env filepath, e.g. configs/local.env", default=None)

parser.add_argument("--debug", help="enable debug", action="store_true")
parser.add_argument("--host", help="http listening host", default="127.0.0.1")
parser.add_argument("--port", help="http listening port", type=int, default=7860)

if app_args := os.environ.get("APP_ARGS"):
    print(f"==> APP_ARGS: {app_args}")
    app_args = shlex.split(app_args)

args = parser.parse_args(args=app_args)
print(f"==> Parsed args: {args}")

css = Path("src") / "assets" / "style.css"
with open(css, 'r') as f:
    css = f.read()

system_prompt = """
You are a helpful assistant in a clothes store. You should try to gently encourage 
the customer to try items that are on sale...
""".strip().replace("\n", "")

user_prompt = """
Hi, I just walked into the store. What do you recommend?
""".strip().replace("\n", "")

upload_file_types = [".txt", ".pdf", ".docx", ".odt", ".epub"]
upload_dir = Path("data") / "uploads"


#### 2.
def save_uploaded_files(files):
    now = datetime.now(UTC)
    save_dir = upload_dir / (str(now.date()) + "-utc")
    os.makedirs(save_dir, exist_ok=True)

    filenames = []
    for file in files:
        filepath = Path(file.name)
        save_path = save_dir / filepath.name
        shutil.copy(file.name, save_path)
        filenames.append(repr(save_path.name))

    return save_dir, filenames


def chat(user_input, history, system_promt, user_prompt, files):
    # print(f"??? history: {history}")

    if files:
        #filenames = [v.name for v in files]
        save_dir, filenames = save_uploaded_files(files)
        print(f"📎 Uploaded: {save_dir}, {', '.join(filenames)}")

    user_input['text'] = user_input['text'].strip()
    msg = {"role": "user", "content": user_input['text']}

    if user_input['text'] == "" and not len(user_input['files']) == 0:
        return msg, history

    messages = [{"role": "system", "content": system_promt}] + \
        history + [msg]

    history.append(msg)

    print(f"--> TODO: messages={messages}")
    reply = {"role": "user", "content": user_input['text'].upper()}
    history.append(reply)

    return reply, history


#### 3.
with gr.Blocks(title="Gradio App", css=css) as webui:
    with gr.Row():
        with gr.Column(scale=1):
            system_prompt_input = gr.Textbox(
                label="System Prompt",
                value=system_prompt,
                lines=5, max_lines=5,
            )

            user_prompt_input = gr.Textbox(
                label="User Prompt",
                value=user_prompt,
                lines=5, max_lines=5,
            )

            upload_files = gr.File(
                label=f"Upload files: {', '.join(upload_file_types)}",
                file_types=upload_file_types,
                file_count="multiple",
            )

        with gr.Column(scale=3):
            chatbot = gr.Chatbot(
                label="Conversation", show_label=False,
                type='messages', elem_id="my-chatbot",
            )

            chat_interface = gr.ChatInterface(
                fn=chat, type="messages",
                chatbot=chatbot, # textbox=gr.Textbox(),
                additional_inputs=[system_prompt_input, user_prompt_input, upload_files],
                #additional_inputs_accordion="📎 Upload files & Prompt",
                additional_outputs=[chatbot],
                multimodal=True, autofocus=True, flagging_mode="manual",
            )


#### 4.
if __name__ == "__main__":
    webui.launch(
        share=False,
        debug=False,
        quiet=False,
        enable_monitoring=True,
        max_threads=8,

        server_name=args.host,
        server_port=args.port,
        root_path="",
        allowed_paths=None,
        auth=None,
        auth_message="Gradio",
        max_file_size=None,

        #favicon_path="fav.ico",
        ssl_keyfile=None,
        ssl_certfile=None,
        ssl_keyfile_password=None,
        #ssr_mode=True,
    )
