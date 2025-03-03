#!/usr/bin/env python3

import numpy as np


onehots = {
  "cat": np.array([1, 0, 0, 0]),
  "the": np.array([0, 1, 0, 0]),
  "dog": np.array([0, 0, 1, 0]),
  "sat": np.array([0, 0, 0, 1]),
}

####
sentence = ["the", "cat", "sat"]

x = onehots[sentence[0]] + onehots[sentence[1]] + onehots[sentence[2]]

print(f"Sent Encoding: {x}")

####
sentence = ["cat", "cat", "cat"]

x = onehots[sentence[0]] + onehots[sentence[1]] + onehots[sentence[2]]

print(f"Sent Encoding: {x}")
