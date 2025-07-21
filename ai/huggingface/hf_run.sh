#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


huggingface-cli login


git clone https://huggingface.co/black-forest-labs/FLUX.1-dev black-forest-labs/FLUX.1-dev.model

git config --global credential.helper store
git clone https://huggingface.co/black-forest-labs/FLUX.1-dev black-forest-labs/FLUX.1-dev.model

export HF_TOKEN=hf_xxxxxxxx


```python
from diffusers import DiffusionPipeline

# pipe = DiffusionPipeline.from_pretrained("black-forest-labs/FLUX.1-dev")
pipe = DiffusionPipeline.from_pretrained("black-forest-labs/FLUX.1-dev.model")

prompt = "Astronaut in a jungle, cold color palette, muted colors, detailed, 8k"
image = pipe(prompt).images[0]

image.save("output.jpeg", format="jpeg")
```
