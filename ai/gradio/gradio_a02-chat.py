#!/usr/bin/env python3
import os
import gradio as gr


system_message = "You are a helpful assistant in a clothes store. You should try to gently encourage \
the customer to try items that are on sale. Hats are 60% off, and most other items are 50% off. \
For example, if the customer says 'I'm looking to buy a hat', \
you could reply something like, 'Wonderful - we have lots of hats - including several that are part of our sales event.'\
Encourage the customer to buy hats if they are unsure what to get."


FILE_TYPES = [".txt", ".pdf", ".docx"]

def save_uploaded_files(file):
    saved_paths = []
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")

    for file in files:
        filename = os.path.basename(file.name)
        save_path = os.path.join(UPLOAD_DIR, f"{timestamp}_{filename}")
        shutil.copy(file.name, save_path)
        saved_paths.append(save_path)

    return saved_paths


def chat(message, history, files):
    if files:
        filenames = [v.name for v in files]
        print(f"📎 Uploaded: {', '.join(filenames)}")

    message = message.strip()
    if message == "":
        return []
   
    messages = [{"role": "system", "content": system_message}] + \
         history + [{"role": "user", "content": message}]

    return [message.upper()]


#demo = gr.ChatInterface(
#    fn=chat,
#    type="messages",
#    additional_inputs=gr.File(
#        label=f"Upload docs: {', '.join(FILE_TYPES)}",
#        file_types=FILE_TYPES,
#        file_count="multiple",
#    ),
#    additional_inputs_accordion="📎 Upload files",
#)

# demo.launch(share=False, server_name="127.0.0.1", server_port=7860)

with gr.Blocks(title="Chatbot with gradio") as demo:
    view = gr.ChatInterface(
        fn=chat,
        type="messages",
        additional_inputs=gr.File(
            label=f"Upload docs: {', '.join(FILE_TYPES)}",
            file_types=FILE_TYPES,
            file_count="multiple",
        ),
        additional_inputs_accordion="📎 Upload files",
    )

demo.launch(share=False, server_name="127.0.0.1", server_port=7860)
