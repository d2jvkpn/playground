#!/usr/bin/env python3
import json


class Params():
    def __init__(self, name="Params", **kwargs):
        #setattr(self, "version", version)
        self.name = name
        self.__keys = []

        for k, v in kwargs.items():
            self.__keys.append(k)
            setattr(self, k, v)

    # print or str()
    def __str__(self):
        values = {k: getattr(self, k) for k in self.__keys}
        json_str = json.dumps(values, ensure_ascii=False)
        return f"{self.name}: {json_str}"

    # interactive shell
    def __repr__(self):
        values = [f"{k}={repr(getattr(self, k))}" for k in self.__keys]
        text = ', '.join(values)
        return f"{self.name}({text})"

    def set(self, **kwargs):
        for k, v in kwargs.items():
            if k not in self__keys:
                self.__keys.append(k)

            setattr(self, k, v)


if __name__ == "__main__":
    p = Params(a=1, b=42)
    print(p)

    p = Params("model", a=1, b=42)
    print(p)
