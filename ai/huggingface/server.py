import gradio as gr
from transformers import pipeline


model_name = os.sys.argv[1] # "bert-base-uncased"
model_dir = os.path.join("data", model_name)

# 加载 Hugging Face 模型
model = pipeline("text-generation", model=model_dir)

# 定义模型推理函数
def generate_text(input_text):
    output = model(input_text, max_length=50)
    return output[0]['generated_text']

# 创建 Gradio 界面
iface = gr.Interface(
    fn=generate_text,
    inputs="text",
    outputs="text",
    title="Hugging Face Model Demo",
    description="Generate text using " + model_name,
)

# 启动 Gradio 应用
iface.launch(server_name="0.0.0.0", server_port=7860)
