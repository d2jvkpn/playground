#!/usr/bin/env python3

import os
import shutil
from datetime import datetime
import gradio as gr

FILE_TYPES = [".txt", ".pdf", ".docx"]
UPLOAD_DIR = "uploads"
os.makedirs(UPLOAD_DIR, exist_ok=True)

def save_uploaded_files(files):
    saved_paths = []
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")

    for file in files:
        filename = os.path.basename(file.name)
        save_path = os.path.join(UPLOAD_DIR, f"{timestamp}_{filename}")
        shutil.copy(file.name, save_path)
        saved_paths.append(save_path)

    return saved_paths

def chat(message, history, system_promt, user_prompt, files):
    if system_promt:
        print(f"==> system_promt: {system_promt}")

    if user_prompt:
        print(f"==> user_prompt: {user_prompt}")

    if files:
        filenames = [v.name for v in files]
        print(f"📎 Uploaded: {', '.join(filenames)}")

    message = message.strip()
    if message == "":
        return []

    messages = [{"role": "system", "content": system_promt}] + \
               history + \
               [{"role": "user", "content": message}]

    return [message.upper()]

with gr.Blocks(title="Chatbot with editable system prompt") as demo:
    with gr.Row():
        with gr.Column(scale=1):
            system_prompt_input = gr.Textbox(
                label="System Prompt",
                value="You are a helpful assistant in a clothes store. You should try to gently encourage the customer to try items that are on sale...",
                lines=2,
                max_lines=5,
            )
            user_prompt_input = gr.Textbox(
                label="User Prompt (pre-context)",
                value="Hi, I just walked into the store. What do you recommend?",
                lines=2,
                max_lines=5,
            )

        with gr.Column(scale=1):
            file_input = gr.File(
                label=f"Upload docs: {', '.join(FILE_TYPES)}",
                file_types=FILE_TYPES,
                file_count="multiple",
            )

    view = gr.ChatInterface(
        fn=chat,
        type="messages",
        additional_inputs=[system_prompt_input, user_prompt_input, file_input],
        additional_inputs_accordion="📎 Upload files & Prompt"
    )

demo.launch(share=False, server_name="127.0.0.1", server_port=7860)
