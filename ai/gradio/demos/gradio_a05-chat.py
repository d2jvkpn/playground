#!/usr/bin/env python3
import os, shutil
from pathlib import Path

from datetime import datetime
import gradio as gr

system_prompt = """
You are a helpful assistant in a clothes store. You should try to gently encourage 
the customer to try items that are on sale...
""".strip().replace("\n", "")

user_prompt = """
Hi, I just walked into the store. What do you recommend?
""".strip().replace("\n", "")

upload_file_types = [".txt", ".pdf", ".docx"]
upload_dir = Path("data") / "uploads"
os.makedirs(upload_dir, exist_ok=True)

def save_uploaded_files(files):
    saved_paths = []
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")

    for file in files:
        filename = os.path.basename(file.name)
        save_path = os.path.join(upload_dir, f"{timestamp}_{filename}")
        shutil.copy(file.name, save_path)
        saved_paths.append(save_path)

    return saved_paths


def chat(user_input, history, system_promt, user_prompt, files):
    if files:
        filenames = [v.name for v in files]
        print(f"📎 Uploaded: {', '.join(filenames)}")

    user_input['text'] = user_input['text'].strip()
    if user_input['text'] == "" and not len(user_input['files']) == 0:
        return []

    messages = [{"role": "system", "content": system_promt}] + \
        history + \
        [{"role": "user", "content": user_input['text']}]

    return [user_input['text'].upper()]

with gr.Blocks(title="Chatbot with editable system prompt") as webui:
    with gr.Row():
        with gr.Column(scale=1):
            system_prompt_input = gr.Textbox(
                label="System Prompt",
                value=system_prompt,
                lines=5,
                max_lines=5,
            )

            user_prompt_input = gr.Textbox(
                label="User Prompt",
                value=user_prompt,
                lines=5,
                max_lines=5,
            )

            upload_files = gr.File(
                label=f"Upload files: {', '.join(upload_file_types)}",
                file_types=upload_file_types,
                file_count="multiple",
            )

        with gr.Column(scale=3):
            view = gr.ChatInterface(
                fn=chat,
                type="messages",
                additional_inputs=[system_prompt_input, user_prompt_input, upload_files],
                additional_inputs_accordion="📎 Upload files & Prompt",
                multimodal=True, autofocus=True,
            )

webui.launch(share=False, server_name="127.0.0.1", server_port=7860)
