#!/usr/bin/env python3
from pathlib import Path

import numpy as np
np.random.seed(42)


data_dir = Path("data")
data_dir.mkdir(parents=True, exist_ok=True)

ds = np.arange(10_000_000, dtype=np.float32)

np.save(data_dir / "data.npy", ds)

# 用内存映射方式读取，不会一次性加载到内存
ds = np.load(data_dir / "data.npy", mmap_mode="r")

print(type(ds))     # <class 'numpy.memmap'>
print(ds.shape)     # (10000000,)
print(ds[100])      # 可以像普通 ndarray 一样访问
