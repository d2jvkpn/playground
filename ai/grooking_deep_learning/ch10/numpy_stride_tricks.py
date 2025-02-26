import numpy as np

# 输入数组
x = np.array([
  [1, 2, 3],
  [4, 5, 6],
  [7, 8, 9],
])

# 使用 as_strided 提取 2x2 子矩阵
shape = (2, 2, 2, 2)                   # 输出形状：2x2 个 2x2 子矩阵
strides = x.strides + x.strides  # 步幅：沿行和列滑动
patches = np.lib.stride_tricks.as_strided(x, shape=shape, strides=strides)

print("输入数组:")
print(x)
print("\n提取的 2x2 子矩阵:")
print(patches)
