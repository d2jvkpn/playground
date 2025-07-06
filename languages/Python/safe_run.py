#!/usr/bin/env python3
import traceback


def safe_run(func):
    def wrapper(*args, **kwargs):
        try:
            return func(*args, **kwargs)
        except ZeroDivisionError:
            print(f"!!! ZeroDivisionError")
            return None
        except Exception as e:
            traceback.print_exc()
            print(f"!!! UnexpectedError: {args}, {kwargs}\n    {e}")
            return None

    return wrapper


####
@safe_run
def divide(a, b):
    return a / b

print(divide(10, 2))
print(divide(10, 0))
