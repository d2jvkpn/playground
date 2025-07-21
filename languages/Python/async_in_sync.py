#!/usr/bin/env python3
import asyncio, threading


_event_loop = None
_event_lock = threading.Lock()

def run_async(coro):
    global _event_loop

    if not _event_loop:
        with _event_lock:
            if not _event_loop:
                _event_loop = asyncio.new_event_loop()

                threading.Thread(
                    target=_event_loop.run_forever, daemon=True, name="AsyncRunner",
                ).start()

    return asyncio.run_coroutine_threadsafe(coro, _event_loop)


if __name__ == '__main__':
    async def double(x):
        await asyncio.sleep(0.02)
        return x * 2

    def sync_double(x):
        future = run_async(double(x))
        return future.result()

    print(sync_double(10))
