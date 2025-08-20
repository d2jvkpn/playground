#!/usr/bin/env python3
import traceback


####
def fn01():
    #raise Exception("error from fn01")
    raise Exception({"code": 1, "msg": "an error"})

try:
    print("==> Try...")
    fn01()
except Exception as e:
    print()
    info = traceback.format_exc()
    print(f"==> Traceback: {repr(info)}")
    print(f"==> Got Error: value={e}, type={type(e).__name__}, args={e.args}")
    if len(e.args) > 0:
        print(f"    type(e.args[0]) = {type(e.args[0])}")
finally:
    print("==> Finally")


class MyException(Exception):
    def __init__(self, msg: str, code: int = 0, details: dict = {}):
        self.msg = msg
        self.code = code
        self.details = details
        super().__init__(msg)


####
try:
    raise MyException("file not found", 404, {"filepath": "data/42.txt"})
except MyException as e:
    print()
    #msg = e.msg.encode('unicode_escape').decode('utf-8')
    print(f"==> Got MyException: msg={repr(e.msg)}, code={e.code}, details={e.details}")
