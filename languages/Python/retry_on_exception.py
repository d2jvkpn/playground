#!/usr/bin/env python3
import time, functools


def retry_on_exception(max_retries=3, delay=1, exceptions=(Exception,)):
    def decorator(func):
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            last_exception = None

            for attempt in range(1, max_retries + 1):
                try:
                    return func(*args, **kwargs)
                except exceptions as e:
                    print(f"->< [Retry] {func.__name__} failed {attempt}/{max_retries}: {e}")
                    last_exception = e
                    time.sleep(delay)

            print(f"!!! [Failed] {func.__name__} failed after {max_retries} retries.")
            raise last_exception

        return wrapper

    return decorator


####
import random


@retry_on_exception(max_retries=5, delay=2)
def flaky_operation():
    if random.random() < 0.7:
        raise ValueError("Simulated random failure")
    return "Success!"

print(flaky_operation())
