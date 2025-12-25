#!/usr/bin/env python3
import io

import requests
import soundfile as sf
import numpy as np
import torch


def audio_from_url(url: str, timeout_secs: int = 10, max_secs: float = 0.0):
    # 1) download
    r = requests.get(url, timeout=timeout_secs) # headers={"User-Agent": "ComfyUI-AudioURL/1.0"}
    r.raise_for_status()
    data = io.BytesIO(r.content)

    # 2) decode
    # always_2d=True -> shape (frames, channels)
    wav, sr = sf.read(data, dtype="float32", always_2d=True)

    # 3) length control
    if max_secs and max_secs > 0:
        max_samples = int(round(max_secs * sr))
        if max_samples < 1:
            raise ValueError(f"max_secs too small -> max_samples={max_samples}")

        cur_samples = wav.shape[0]

        if cur_samples > max_samples: # 截断
            wav = wav[:max_samples, :]
        #elif pad_to_length and cur_samples < max_samples:
           # 补零（尾部 padding）
           #pad = np.zeros((max_samples - cur_samples, wav.shape[1]), dtype=np.float32)
           #wav = np.concatenate([wav, pad], axis=0)

    # 4) to torch, ComfyUI AUDIO expects shape: [batch, channels, samples]
    # sf returns (samples, channels), so transpose -> (channels, samples)
    wav = wav.T  # (C, T)
    audio = torch.from_numpy(wav).unsqueeze(0)  # (1, C, T)

    # 5) package as ComfyUI AUDIO dict
    audio_dict = { "waveform": audio, "sample_rate": int(sr) }

    return audio_dict

def audio_info(audio: dict):
    wf = audio.get("waveform", None)
    sr = int(audio.get("sample_rate", 0))

    if wf is None or not isinstance(wf, torch.Tensor):
        raise ValueError("Invalid AUDIO: missing waveform tensor")

    # ComfyUI 常见: [batch, channels, samples]
    if wf.ndim == 3:
        b, c, t = wf.shape
    elif wf.ndim == 2:
        # 有些自定义节点可能传 [channels, samples]
        b, (c, t) = 1, wf.shape
        wf = wf.unsqueeze(0)
    else:
        raise ValueError(f"Unexpected waveform shape: {tuple(wf.shape)}")

    duration_sec = (t / sr) if sr > 0 else None

    # 统计（避免过慢：只在 CPU 上做）
    x = wf.detach().float().cpu()
    peak = float(x.abs().max().item())
    rms = float(torch.sqrt(torch.mean(x * x)).item())
    #is_silent = peak < 1e-4

    return {
        "sample_rate": sr,
        "batch": b,
        "channels": c,
        "samples_per_channel": t,
        "duration_sec": round(duration_sec, 3),
        "peak": round(peak, 3),
        "rms": round(rms, 3),
        #"silent": is_silent,
        "dtype": str(wf.dtype),
        "device": str(wf.device),
    }

if __name__ == "__main__":
    import os

    audio = audio_from_url(os.sys.argv[1])
    print(f"--> audio:\n{audio}")

    print(audio_info(audio))
