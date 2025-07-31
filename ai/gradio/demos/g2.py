#!/usr/bin/env python3

import gradio as gr

with gr.Blocks() as demo:
    with gr.Row():
        with gr.Column(scale=1):
            gr.Markdown("侧边栏模拟")
        with gr.Column(scale=4):
            with gr.Tab("首页"):
                gr.Textbox(label="欢迎来到首页")
            with gr.Tab("数据分析"):
                gr.Dataframe([[1,2],[3,4]])
            with gr.Tab("设置"):
                gr.Slider(label="调整值", minimum=0, maximum=100)

demo.launch()
