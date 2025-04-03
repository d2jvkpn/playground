#!/usr/bin/env python3

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
