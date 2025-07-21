#!/usr/bin/env python3

import gradio as gr

def greet(session_id):
    return f"欢迎，你的会话 ID 是：{session_id}"

with gr.Blocks() as demo:
    session_id = gr.State("")
    out = gr.Textbox(label="会话信息", interactive=False)

    # ✅ 使用组件的 .load 方法支持 _js 参数
    out.load(
        fn=greet,
        inputs=[session_id],
        outputs=out,
        _js="""
            () => {
                let sid = localStorage.getItem("session_id");
                if (!sid) {
                    sid = crypto.randomUUID();
                    localStorage.setItem("session_id", sid);
                }
                return sid;
            }
        """
    )

demo.launch()
