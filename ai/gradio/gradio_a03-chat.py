#!/usr/bin/env python3
import os, shutil
from datetime import datetime

import gradio as gr


UPLOAD_DIR = "uploaded_files"
os.makedirs(UPLOAD_DIR, exist_ok=True)

# 保存文件到指定目录并返回保存路径列表
def save_files(files):
    saved = []
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")

    for f in files:
        filename = os.path.basename(f.name)
        save_path = os.path.join(UPLOAD_DIR, f"{timestamp}_{filename}")
        shutil.copy(f.name, save_path)
        saved.append(save_path)

    return saved

# 聊天逻辑函数
def chat_fn(user_msg, files, history):
    responses = history or []
    user_msg = user_msg.strip()
    no_msg = not user_msg

    if no_msg and not files:
        return responses, None

    if files:
        saved_paths = save_files(files)
        user_msg += "\n--------UPLOADED--------\n"
        user_msg += "\n".join([f"- {os.path.basename(p)}" for p in saved_paths])

    print("???", history)
    bot_reply = None if no_msg else f"🧠 收到：{user_msg}"

    responses.append((user_msg, bot_reply))

    return responses, None

# 构建 UI
with gr.Blocks(title="Chatbot") as demo:
    # gr.Markdown("## 🤖 Chatbot")
    chatbot = gr.Chatbot(label="")

    with gr.Row():
        with gr.Column(scale=4):
            msg_input = gr.Textbox(
                placeholder="输入你的消息", label="✏️ 消息输入",
                lines=4, max_lines=10, show_label=True,
            )

            with gr.Row():
                clear_btn = gr.Button("❌ Clear", variant="secondary")
                send_btn = gr.Button("📨 Send", variant="primary")

        file_types = [".pdf", ".txt", ".docx"]
        with gr.Column(scale=1):
            file_input = gr.File(
                label=f"📂 Upload files: {', '.join(file_types)}",
                file_types=file_types,
                file_count="multiple",
            )

    state = gr.State([])

    send_btn.click(
        fn=chat_fn,
        inputs=[msg_input, file_input, state],
        outputs=[chatbot, file_input]
    ).then(
        lambda x: "", inputs=msg_input, outputs=msg_input,
    ).then(
        lambda x: x, inputs=chatbot, outputs=state,
    )

    clear_btn.click(
        lambda: ([], "", None),
        None,
        [chatbot, msg_input, file_input]
    ).then(
        lambda: [], None, state
    )

demo.launch()
