| 后缀           | 全称                                         | 含义                            | 常见用法 / 示例                |
| ------------ | ------------------------------------------ | ----------------------------- | ------------------------ |
| **pt**       | pretrained                                 | 只做了大规模预训练，没有微调                | `gemma-3-270m-pt`        |
| **base**     | base model                                 | 同 `pt`，通常表示“基础模型”             | `llama-3-8b-base`        |
| **it**       | instruction tuned                          | 指令微调过，更擅长遵循用户指令               | `gemma-3-270m-it`        |
| **instruct** | instruction tuned                          | 同 `it`，名字更直白                  | `flan-t5-small-instruct` |
| **chat**     | chat tuned                                 | 在对话数据上微调过，优化多轮交互              | `llama-2-7b-chat`        |
| **sft**      | supervised fine-tuned                      | 在人工标注的问答/指令数据上做有监督微调          | `mistral-7b-sft`         |
| **rlhf**     | reinforcement learning from human feedback | 加了人类反馈强化学习，优化输出质量和偏好          | `opt-rlhf`               |
| **alpaca**   | （特定项目名）                                    | 在 Stanford Alpaca 指令数据集上微调的版本 | `llama-7b-alpaca`        |
| **dpo**      | direct preference optimization             | 用偏好数据做训练的版本（替代 RLHF 的方法）      | `mistral-7b-dpo`         |
| **ft**       | fine-tuned                                 | 笼统表示做过微调，具体看上下文               | `bert-base-ft-ner`       |
| **lora**     | LoRA fine-tuned                            | 用 **LoRA** 方法微调过，参数高效         | `llama-2-7b-lora`        |
