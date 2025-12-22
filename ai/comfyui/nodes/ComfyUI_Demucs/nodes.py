import torch
from demucs.pretrained import get_model
from demucs.apply import apply_model

# torch checkpoint: ~/.cache/torch/hub/checkpoints/

class DemucsSeparator:
    @classmethod
    def INPUT_TYPES(cls):
        return {
            "required": {
                "audio": ("AUDIO",),
                "model_name": (["htdemucs", "htdemucs_ft"], {"default": "htdemucs"}),
            }
        }

    RETURN_TYPES = ("AUDIO", "AUDIO")
    RETURN_NAMES = ("vocals", "instrumental")
    FUNCTION = "run"
    CATEGORY = "Audio/Demucs"

    def run(self, audio, model_name):
        waveform = audio["waveform"]
        print("waveform shape:", audio["waveform"].shape)

        if waveform.ndim == 2:            # [C, T] -> [1, C, T]
            waveform = waveform.unsqueeze(0)
        elif waveform.ndim == 3:
            pass                          # 已经是 [B, C, T]，别再 unsqueeze
        elif waveform.ndim == 4:
            waveform = waveform.squeeze() # 常见情况：多了一个 1 维，尽量压掉
            if waveform.ndim == 2:
                waveform = waveform.unsqueeze(0)  # [C,T] -> [1,C,T]
            elif waveform.ndim != 3:
                raise ValueError(f"Unexpected waveform shape after squeeze: {waveform.shape}")
        else:
            raise ValueError(f"Unexpected waveform ndim: {waveform.ndim}, shape={waveform.shape}")

        sr = audio["sample_rate"]
        device = "cuda" if torch.cuda.is_available() else "cpu"

        model = get_model(model_name).to(device)
        model.eval()

        with torch.no_grad():
            sources = apply_model(
                model,
                waveform.to(device),  # [1, C, T]
                device=device,
                split=True,
                overlap=0.25,
            )[0]

        # Demucs 标准顺序: drums, bass, other, vocals
        vocals = sources[3].cpu()
        instrumental = (sources[0] + sources[1] + sources[2]).cpu()

        return (
            { "waveform": vocals, "sample_rate": sr },
            { "waveform": instrumental, "sample_rate": sr },
        )

NODE_CLASS_MAPPINGS = {
    "DemucsSeparator": DemucsSeparator,
}

NODE_DISPLAY_NAME_MAPPINGS = {
    "DemucsSeparator": "DemucsSeparator Audio→Audio",
}
