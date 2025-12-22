#!/usr/bin/env python3
import os
import torch
import torchaudio
import folder_paths

# ComfyUI helper
import folder_paths

# -----------------------------
# Audio helpers (ComfyUI AUDIO)
# -----------------------------
def audio_to_mono_1t(audio):
    wf = audio["waveform"]
    sr = int(audio["sample_rate"])
    if wf.dim() == 3:
        wf = wf[0]  # [C,T]
    if wf.dim() == 2:
        wf = wf.mean(dim=0, keepdim=True)  # [1,T]
    elif wf.dim() == 1:
        wf = wf.unsqueeze(0)
    return wf.float().contiguous(), sr

def mono_1t_to_audio(wave_1t, sr):
    if wave_1t.dim() == 1:
        wave_1t = wave_1t.unsqueeze(0)
    wave_bct = wave_1t.unsqueeze(0)  # [1,1,T]
    return {"waveform": wave_bct, "sample_rate": int(sr)}

def ensure_sr(wave_1t, sr_in, sr_out):
    if sr_in == sr_out:
        return wave_1t
    return torchaudio.functional.resample(wave_1t, sr_in, sr_out)

# -----------------------------
# Nodes
# -----------------------------
class MDXNet_Separate:
    """
    MDX-Net (ONNX) separator node via 'audio-separator'
    Outputs: vocals, instrumental
    """

    @classmethod
    def INPUT_TYPES(cls):
        # 这里用 STRING 输入模型路径，最通用（不用改 folder_paths）
        return {
            "required": {
                "audio": ("AUDIO",),
                "model_onnx_path": ("STRING", {"default": "UVR_MDXNET_KARA_2.onnx"}),
                "output_sample_rate": ("INT", {"default": 44100, "min": 8000, "max": 96000}),
                "chunk_size": ("INT", {"default": 352800, "min": 44100, "max": 3528000}),
                "overlap": ("FLOAT", {"default": 0.25, "min": 0.0, "max": 0.95, "step": 0.01}),
            },
            "optional": {
                "use_gpu": ("BOOLEAN", {"default": True}),
            }
        }

    RETURN_TYPES = ("AUDIO", "AUDIO")
    RETURN_NAMES = ("vocals", "instrumental")
    FUNCTION = "run"
    CATEGORY = "Audio/Separation"

    def run(self, audio, model_onnx_path, output_sample_rate, chunk_size, overlap, use_gpu=True):
        # Lazy import so ComfyUI still loads if deps missing
        try:
            from audio_separator.separator import Separator
        except Exception as e:
            raise RuntimeError(
                "Missing dependency: audio-separator. Install with:\n"
                "  pip install audio-separator onnxruntime\n"
                "Or on GPU:\n"
                "  pip install audio-separator onnxruntime-gpu\n"
                f"\nOriginal import error: {e}"
            )

        model_dir = os.path.join(folder_paths.get_models_dir(), "mdxnet")
        os.makedirs(model_dir, exist_ok=True)

        # Resolve path (allow relative to ComfyUI root)
        #if not os.path.isabs(model_onnx_path):
        #    # ComfyUI root is typically cwd
        #    model_onnx_path = os.path.abspath(model_onnx_path)

        #if not os.path.exists(model_onnx_path):
        #    raise FileNotFoundError(f"MDX model not found: {model_onnx_path}")

        wave, sr = audio_to_mono_1t(audio)
        wave = ensure_sr(wave, sr, int(output_sample_rate))

        # audio-separator expects file path OR numpy. We'll use temp file for robustness.
        out_dir = os.path.join(folder_paths.get_temp_directory(), "mdxnet")
        os.makedirs(out_dir, exist_ok=True)
        in_path = os.path.join(out_dir, "input.wav")
        info = torchaudio.info(in_path)
        print("[MDX] saved wav:", info.sample_rate, info.num_frames, info.num_channels, in_path)
        torchaudio.save(in_path, wave.cpu(), int(output_sample_rate), encoding="PCM_S", bits_per_sample=16)


        # Configure Separator
        # The library auto-detects ONNX MDX models.
        # Use GPU if user wants and available (ORT GPU package required)
        separator = Separator(
            output_dir=out_dir,
            sample_rate=int(output_sample_rate),
            model_file_dir=model_dir,
            mdx_params={
                "overlap": float(overlap),
                # 你原来的 chunk_size 在 audio-separator 里叫 segment_size（单位通常是“frames/窗口”，不是 samples）
                # 建议先不要硬塞 chunk_size，先用默认，或映射为 mdx_params["segment_size"]
                # "segment_size": 256,
            },
            use_autocast=bool(use_gpu and torch.cuda.is_available()),
        )

        separator.load_model(model_filename=model_onnx_path)

        # Separate -> returns output file paths
        # Typically outputs ["...Vocals.wav", "...Instrumental.wav"] or similar
        output_names = {"Vocals": "vocals", "Instrumental": "instrumental"}
        out_files = separator.separate(in_path, output_names=output_names)
        if isinstance(out_files, dict):
            out_files = list(out_files.values())
        elif out_files is None:
            out_files = []

        # Load results
        # Try to find vocals/instrumental by filename keywords
        vocals_path = None
        inst_path = None
        for p in out_files:
            lp = p.lower()
            if "vocal" in lp:
                vocals_path = p
            elif "inst" in lp or "karaoke" in lp or "music" in lp:
                inst_path = p

        # Fallback: take first two
        if vocals_path is None or inst_path is None:
            if len(out_files) >= 2:
                vocals_path, inst_path = out_files[0], out_files[1]
            else:
                raise RuntimeError(f"Separator returned unexpected outputs: {out_files}")

        v_wf, v_sr = torchaudio.load(vocals_path)
        i_wf, i_sr = torchaudio.load(inst_path)

        # Convert to mono [1,T]
        v_wf = v_wf.mean(dim=0, keepdim=True)
        i_wf = i_wf.mean(dim=0, keepdim=True)

        # Ensure same SR
        if v_sr != output_sample_rate:
            v_wf = torchaudio.functional.resample(v_wf, v_sr, int(output_sample_rate))
        if i_sr != output_sample_rate:
            i_wf = torchaudio.functional.resample(i_wf, i_sr, int(output_sample_rate))

        return (mono_1t_to_audio(v_wf, int(output_sample_rate)),
                mono_1t_to_audio(i_wf, int(output_sample_rate)))

NODE_CLASS_MAPPINGS = {
    "MDXNet_Separate": MDXNet_Separate,
}

NODE_DISPLAY_NAME_MAPPINGS = {
    "MDXNet_Separate": "MDX-Net (ONNX) Separate Vocals/Instructmental",
}
