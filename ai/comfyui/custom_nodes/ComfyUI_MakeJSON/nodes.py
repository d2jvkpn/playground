#!/usr/bin/env python3
import json

class MakeJSON:
    @classmethod
    def INPUT_TYPES(cls):
        return {
            "required": {
                "firstname": ("STRING", {"default": "Jane"}), 
                "lastname": ("STRING", {"default": "Doe"}), 
                "score": ("INT", {"default": 0}),
            },
            "optional": {
                "description": ("STRING", {"default": ""}),
            }
        }

    RETURN_TYPES = ("STRING",)
    RETURN_NAMES = ("json",)
    FUNCTION = "run"
    CATEGORY = "Utils/data"

    def run(self, firstname, lastname, score, description=""):
        obj = {
            "firstname": firstname,
            "lastname": lastname,
            "score": int(score),
            "description": description,
        }

        s = json.dumps(obj, indent=2,  ensure_ascii=False)
        return (s,)


NODE_CLASS_MAPPINGS = {
    "MakeJSON": MakeJSON,
}

NODE_DISPLAY_NAME_MAPPINGS = {
    "MakeJSON": "MakeJSON JSON→Text",
}
