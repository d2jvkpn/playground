#!/usr/bin/env python3
import os, argparse
from pathlib import Path
from datetime import datetime

import dotenv
import torch
from transformers import AutoTokenizer, AutoModelForCausalLM, BitsAndBytesConfig


def model_cache_path(model_id):
    home_dir = Path.home()
    cache_dir = os.environ.get('HF_HUB_CACHE',  home_dir / ".cache" / "huggingface" / "hub")

    model_hf = Path(cache_dir) / ("models--" + model_id.replace("/", "--"))
    model_ref = (model_hf / "refs" / "main").read_text(encoding="utf-8").strip()
    model_path = model_hf / "snapshots" / model_ref

    return model_path

def now():
    return datetime.now().astimezone().strftime("%FT%T%:z")

#### 1.
parser = argparse.ArgumentParser(
    description="huggingface chat",
    formatter_class=argparse.ArgumentDefaultsHelpFormatter,
)

parser.add_argument("--model_id", help="huggingface model id", default="google/gemma-3-270m-it") # required=True
parser.add_argument("--env", help="environment file", default=Path("configs") / "local.env")
parser.add_argument("--q4", help="Quantization 4bit", action="store_true")
parser.add_argument("--system_prompt", help="system prompt", default="You are a concise assistant.")

args = parser.parse_args()
print(f"{now()} ==> args: {args}")

dotenv.load_dotenv(args.env)

if os.getenv("HF_HUB_OFFLINE", "").lower() in ["1", "true"]:
    model_id = model_cache_path(model_id)
else:
    model_id = args.model_id

#### 2.
quant_config = None
if args.q4:
    quant_config = BitsAndBytesConfig(
        load_in_4bit=True,
        bnb_4bit_use_double_quant=True,
        bnb_4bit_compute_dtype=torch.bfloat16,
        bnb_4bit_quant_type="nf4",
    )
# quant_config = BitsAndBytesConfig(load_in_8bit=True, bnb_8bit_compute_dtype=torch.bfloat16)

tokenizer = AutoTokenizer.from_pretrained(model_id)

model = AutoModelForCausalLM.from_pretrained(
   model_id,
   quantization_config=quant_config,
   device_map="auto",
)

if model.config.pad_token_id == 0:
    model.generation_config.pad_token_id = tokenizer.pad_token_id

print(f"{now()} ==> memory footprint: {model.get_memory_footprint() / 1e9:.1f} GB")

messages = [{ "role": "system", "content": args.system_prompt }]

#### 3.
while True:
    user_input = input(f"{now()} --> Enter: ")
    user_input = user_input.strip()

    if user_input.lower() in ["::quit", "::q"]:
        break

    messages.append({"role": "user", "content": user_input})

    inputs = tokenizer.apply_chat_template(
        messages,
        tokenize=True,
        return_tensors="pt",
        return_dict=True,
        add_generation_prompt=True,
    ).to(model.device)

    outputs = model.generate(
        **inputs,
        max_new_tokens=256,
        temperature=0.7,
        top_p=0.95,
    )

    reply = tokenizer.decode(
        outputs[0][inputs["input_ids"].shape[-1]:],
        skip_special_tokens=True,
    ).strip()

    print(f"{now()} <-- Reply: {reply}")

    messages.append({"role": "assistant", "content": reply})

print(f"{now()} <== Exit")
