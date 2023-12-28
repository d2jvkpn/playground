### Stable Diffusion Webui Docs
---

#### References
- https://github.com/NickLucche/stable-diffusion-nvidia-docker/blob/master/Dockerfile
- https://github.com/huggingface/diffusers
- https://hub.docker.com/r/pytorch/pytorch/tags?page=1
- https://github.com/AUTOMATIC1111/stable-diffusion-webui
- https://huggingface.co/stabilityai/stable-diffusion-2-base
- https://towardsdatascience.com/stable-diffusion-as-an-api-5e381aec1f6
- https://www.bilibili.com/video/BV19M411p7FR

#### ControlNet
- https://github.com/Mikubill/sd-webui-controlnet
- https://github.com/lllyasviel/ControlNet
- https://huggingface.co/lllyasviel/ControlNet/tree/main/models
- https://stablediffusionapi.com/docs/features/v5/controlnet/main
- https://github.com/AUTOMATIC1111/stable-diffusion-webui/discussions/8000
- https://www.philschmid.de/stable-diffusion-controlnet-endpoint
- https://github.com/Mikubill/sd-webui-controlnet/wiki/API#migrating-from-controlnet2img-to-sdapiv12img
- https://huggingface.co/CompVis/stable-diffusion-v-1-4-original/resolve/main/sd-v1-4.ckpt
- https://huggingface.co/CompVis/stable-diffusion-v-1-4-original/resolve/main/sd-v1-4-full-ema.ckpt
- https://civitai.com/models/8453/liuyifei
- https://civitai.com/models/6424/chilloutmix
- https://civitai.com/models/3666/protogen-x34-photorealism-official-release
- ControlNet models: https://huggingface.co/lllyasviel/ControlNet/, https://huggingface.co/lllyasviel/Annotators


#### Gradio frpx proxy
- command
```bash
.local/lib/python3.10/site-packages/gradio/frpc_linux_amd64_v0.2 http -n N3j5OXxAbcXzAMFg2pfy_TEOLk-3XRufPz617e0zbig -l 7860 -i 0.0.0.0 --uc --sd random --ue --server_addr 18.237.145.165:7000 --disable_log_color
```
- https://gradio.app/sharing-your-app/
- https://github.com/gradio-app/gradio/security/advisories/GHSA-3x5j-9vwr-8rr5
- https://www.reddit.com/r/StableDiffusion/comments/xf4gbt/someone_hacked_my_gradio/
- https://github.com/AUTOMATIC1111/stable-diffusion-webui/issues/6484
- disable run launch.py with --share


#### Resources:
- Stable-diffusion: realisticVisionV20_v20.safetensors
  - url: https://civitai.com/models/4201/realistic-vision-v13
  - location: models/Stable-diffusion

- ControlNet
  - url: https://huggingface.co/lllyasviel/ControlNet/tree/main/models
  - location: models/ControlNet
  - items: control_sd15_canny.pth, control_sd15_depth.pth, control_sd15_mlsd.pth

- model_base_caption_capfilt_large.pth
  - url: https://huggingface.co/sunnyweir/model_base_caption_capfilt_large.pth/tree/main
  - location: models/BLIP/model_base_caption_capfilt_large.pth

- StableSAM
  - url: https://huggingface.co/spaces/abhishek/StableSAM/blob/main/sam_vit_h_4b8939.pth
  - location: 

- ??
  - url: https://huggingface.co/lllyasviel/Annotators/resolve/main/ControlNetHED.pth
  - location: extensions/sd-webui-controlnet/annotator/downloads/hed/ControlNetHED.pth
  - location: models/hed/ControlNetHED.pth
  - url: https://huggingface.co/lllyasviel/ControlNet/resolve/main/annotator/ckpts/mlsd_large_512_fp32.pth
  - location: extensions/sd-webui-controlnet/annotator/downloads/mlsd/mlsd_large_512_fp32.pth
  - location: models/mlsd/mlsd_large_512_fp32.pth
  - url: https://huggingface.co/lllyasviel/Annotators/resolve/main/netG.pth
  - location: extensions/sd-webui-controlnet/annotator/downloads/lineart_anime/netG.pth
