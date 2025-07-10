#!/usr/bin/env python3
import gradio as gr

####
def greet(name, model="GPT"):
    return f"Hello, {name}, {model}!"

demo = gr.Interface(
    fn=greet,
    inputs="textbox",
    outputs="textbox",
    flagging_mode="never",
)

####
demo = gr.Interface(
    fn=greet,
    inputs=[gr.Textbox(label="Your message:", lines=6)],
    outputs=[gr.Textbox(label="Response:", lines=8)],
    flagging_mode="never",
)

####
demo = gr.Interface(
    fn=greet,
    inputs=[gr.Textbox(label="Your message:", lines=6)],
    outputs=[gr.Markdown(label="Response:")],
    flagging_mode="never",
)

demo.launch(share=False, server_name="127.0.0.1", server_port=7860)
