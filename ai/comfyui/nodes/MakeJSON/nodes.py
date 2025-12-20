#!/usr/bin/env python3
import json

class MakeJSON:
    @classmethod
    def INPUT_TYPES(cls):
        return {"required": {"name": ("STRING", {"default": "Alan"}), "score": ("INT", {"default": 1})}}

    RETURN_TYPES = ("STRING",)
    RETURN_NAMES = ("json",)
    FUNCTION = "run"
    CATEGORY = "Utils"

    def run(self, name, score):
        obj = {"name": name, "score": int(score)}
        s = json.dumps(obj, ensure_ascii=False, indent=2)
        return (s,)
