#!/usr/bin/env python3

import gradio as gr

#import whisper

#model = whisper.load_model("base")

#def transcribe(audio_path):
#    result = model.transcribe(audio_path)
#    return result["text"]


def transcribe(audio):
    return f"audio_path：{audio}"

with gr.Blocks() as demo:
    mic = gr.Microphone(label="Record", show_label=False, type="filepath")

    output = gr.Textbox()
    mic.change(fn=transcribe, inputs=mic, outputs=output)

demo.launch()
