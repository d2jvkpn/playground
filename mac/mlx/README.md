# MLX
---


## 1. docs
- https://mlx-framework.org/


## 2. installation
```
mkdir -p ~/Workspace
cd Worksapce

python3 -m venv venv/mlx
source venv/mlx/bin/activate

pip config --site set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

pip install -U pip
pip install ipython

#pip install -i https://pypi.tuna.tsinghua.edu.cn/simple mlx-lm mlx-vlm
pip install -U mlx-lm mlx-vlm
```

## 3. mlx
```
mlx_lm.chat --model mlx-community/Qwen3.6-35B-A3B-8b

python -m mlx_vlm.generate \
  --model mlx-community/Qwen3.6-35B-A3B-8bit \
  --max-tokens 512 \
  --temperature 0.0 \
  --prompt "Describe this image." \
  --image test.jpg
```

## 4. mlx-serve
```
brew tap ddalcu/mlx-serve https://github.com/ddalcu/mlx-serve

brew trust --formula ddalcu/mlx-serve/mlx-serve

brew install mlx-serve
```

## 5. pull models
```
for v in $(grep -v "^#" data/models.list); do
    mlx-serve pull $v
done

mlx-serve list


pip install -U huggingface_hub
export HF_XET_HIGH_PERFORMANCE=1

hf download \
  mlx-community/Qwen3.6-35B-A3B-8bit \
  --local-dir ~/.mlx-serve/models/Qwen3.6-35B-A3B-8bit
```

## 6. run
```
mlx-serve run mlx-community/Qwen3.6-35B-A3B-8bit

mlx-serve serve

mlx-serve serve \
  --prefix-cache-disk 20GB \
  --prefix-cache-entries 8 \
  --prefix-cache-mem 4GB \
  --metrics \
  --max-concurrent 1 \
  --pld \
  --kv-quant 8 \
  --ctx-size 262144 \
  --host 0.0.0.0 \
  --port 11234

# --model-dir ~/models/Qwen3.6-35B-A3B-8bit
# --ctx-size 131072
# --ctx-size 262144
# --prefill-chunk 1024
```
