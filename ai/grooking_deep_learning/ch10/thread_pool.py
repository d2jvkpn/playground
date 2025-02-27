#!/usr/bin/env python3

from concurrent.futures import ThreadPoolExecutor
import time

# 定义一个任务函数
def task(name, delay):
    print(f"Task {name} started")
    time.sleep(delay)  # 模拟 I/O 操作
    print(f"Task {name} finished after {delay} seconds")
    return f"Result from {name}"

# 固定线程数为 3
num_threads = 3

# 使用线程池
with ThreadPoolExecutor(max_workers=num_threads) as executor:
    # 提交任务
    futures = [executor.submit(task, f"Thread-{i+1}", i+1) for i in range(5)]

    # 获取任务结果
    for future in futures:
        print(future.result())

print("All tasks completed")
