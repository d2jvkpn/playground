#!/usr/bin/env python3
from pathlib import Path

import numpy as np


# numpy smaple
A = np.array(["apple", "banana", "cherry", "date"])
B = np.array([10, 20, 30, 40]) 

probabilities = B / np.sum(B)

sample_size = 5
sampled_elements = np.random.choice(A, size=sample_size, p=probabilities, replace=False)

print("sample:", sampled_elements)


# custom numpy datatye
dtype = [('name', 'U10'), ('value', 'i4')]

arr = np.array([("hello", 42), ("world", 99)], dtype=dtype)
print(arr)

####
data_dir = Path("data")
data_dir.mkdir(parents=True, exist_ok=True)

arr = np.array(list(range(1_000)))
npy_file = data_dir / "array.npy"

np.save(npy_file, arr)

arr = np.load(npy_file,  mmap_mode='r')


####
mat1 = np.array([
  [1, 2, 3],
  [4, 5, 6],
  [7, 8, 9],
])

mat1 = np.asmatrix('1 2 3; 4 5 6; 7 8 9')

mat1 = np.arange(1, 13).reshape(3, 4)

mat1 = np.arange(0, 20, 2).reshape(2, 5)

mat1 = np.random.randint(0, 100, (3, 5))

mat1 = np.linspace(0, 1, 12).reshape(3, 4)

mat_func = np.fromfunction(lambda i, j: i + j, (3, 4))

mat_sin = np.fromfunction(lambda i, j: np.sin(i) + np.cos(j), (3, 3))

mat_seq = np.array([np.linspace(0, 10, 5) for _ in range(3)])

####
mat_rand = np.random.rand(3, 4)

mat_rand = np.random.random((2, 3))

mat_uniform = np.random.uniform(5, 15, (3, 4))

####
mat1 = np.arange(0, 5)
mat2 = np.arange(0, 50, 1).reshape(5, 10)

assert (mat1 @ mat2).shape == (10, )

####
mat1 = np.arange(0, 5)
mat2 = np.arange(0, 50, 1).reshape(10, 5)

assert (mat1 * mat2).shape == (10, 5)

####
mat1 = np.arange(0, 100, 1).reshape(20, 5)

mat2 = np.arange(0, 50, 1).reshape(5, 10)

ans = mat1 @ mat2

assert ans.shape == (20, 10)
