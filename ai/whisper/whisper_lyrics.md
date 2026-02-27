# Title
---
```meta
date: 1970-01-01
authors: []
version: 0.1.0
```

#### ch01. 
1. docs
- model=large-v3
- pip install faster-whisper demucs
- using Demucs to separate vocals
```
pip install demucs
demucs song.mp3
```
- python
```
from faster_whisper import WhisperModel

model = WhisperModel("large-v3", device="cuda", compute_type="float16")

segments, info = model.transcribe("song.mp3", temperature=0, beam_size=5, word_timestamps=True)
# initial_prompt="These are song lyrics."
# initial_prompt="以下是歌曲歌词。"

for segment in segments:
    print(segment.start, segment.end, segment.text)

with open("lyrics.srt", "w") as f:
    for i, segment in enumerate(segments):
        f.write(f"{i+1}\n")
        f.write(f"{segment.start} --> {segment.end}\n")
        f.write(segment.text.strip() + "\n\n")
```
- align with Montreal Forced Aligner (MFA)
- align with Aeneas
```
python -m aeneas.tools.execute_task \
  vocals.wav \
  lyrics.txt \
  "task_language=eng|is_text_type=plain|os_task_file_format=json" \
  output.json
```
- align with Gentle
- align with whisperX: https://github.com/m-bain/whisperX
