#!/usr/bin/env python3

import gradio as gr
#import whisper

#model = whisper.load_model("base")

def transcribe(audio_path):
    return audio_path
    #result = model.transcribe(audio_path)
    #return result["text"]

with gr.Blocks() as demo:
    #gr.Markdown("## 🎙️ Click to record")

    with gr.Row():
        with gr.Column(scale=1):
           microphone = gr.Microphone(type="filepath", label="Click to record", show_label=False)

        with gr.Column(scale=3):
            audio = gr.Textbox(label="Audio")
    
    microphone.change(fn=transcribe, inputs=[microphone], outputs=[audio])

demo.launch()
