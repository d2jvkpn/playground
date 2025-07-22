#!/usr/bin/env python3
import asyncio
from datetime import datetime


async def foo():
    await asyncio.sleep(1)
    print(f"{datetime.now()} foo done")


async def bar():
    await asyncio.sleep(1)
    print(f"{datetime.now()} bar done")


async def run1():
    results = await asyncio.gather(
        foo(),
        bar(),
    )

    await asyncio.sleep(0.5)
    print("go---")

    print(f"{datetime.now()} all done")


async def run2():
    task1 = asyncio.create_task(foo())
    task2 = asyncio.create_task(bar())

    await asyncio.sleep(0.5)
    print("go---")
    await task1
    await task2


async def run3():
    tasks = [foo(), bar()]

    await asyncio.sleep(0.5)
    print("go---")
    for coro in asyncio.as_completed(tasks):
        result = await coro 


asyncio.run(run3())
