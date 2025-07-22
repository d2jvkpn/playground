#!/usr/bin/env python3

import gradio as gr

def show_content(option):
    return f"你选择了：{option}"

with gr.Blocks() as demo:
    with gr.Row():
        with gr.Column(scale=1):
            gr.Markdown("### 菜单")
            btn1 = gr.Button("首页")
            btn2 = gr.Button("分析")
            btn3 = gr.Button("设置")
        with gr.Column(scale=4):
            output = gr.Textbox(label="内容")

    btn1.click(fn=show_content, inputs=[gr.Textbox(value="首页", visible=False)], outputs=output)
    btn2.click(fn=show_content, inputs=[gr.Textbox(value="分析", visible=False)], outputs=output)
    btn3.click(fn=show_content, inputs=[gr.Textbox(value="设置", visible=False)], outputs=output)

demo.launch()
