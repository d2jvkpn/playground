#!/bin/python3

import numpy as np

# 6*3
streelights = np.array([
  [1, 0, 1],
  [0, 1, 1],
  [0, 0, 1],
  [1, 1, 1],
  [0, 1, 1],
  [1, 0, 1],
])

# 6
walk_vs_stop = np.array([
  0,
  1,
  0,
  1,
  1,
  0,
])

weights = np.array([0.5, 0.48, -0.7])
alpha = 0.1

print("==> streelights={}, walk_vs_stop={}, weights={}, alpha={}".format(
  streelights.shape, walk_vs_stop.shape, weights, alpha,
))

input = streelights[0]
goal = walk_vs_stop[0]

for i in range(40):
    for row in range(streelights.shape[0]):
        input = streelights[row]
        goal = walk_vs_stop[row]
        pred = input.dot(weights)

        delta = pred - goal
        error = delta ** 2
        weights -= alpha*(input * delta)

        if row == streelights.shape[0] - 1:
             print("--> {}-{}: error={}, prediction={}, weights={};".format(
               i+1, row+1, np.round(error, 6), np.round(pred, 6), np.round(weights, 6),
            ))

# weights = [0.013892, 1.013815, -0.015993]

# input        goal    pressure
# [1, 0, 1]    0       - 0 -
# [0, 1, 1]    1       0 + +
# [0, 0, 1]    0       0 0 -
# [1, 1, 1]    1       + + +
# [0, 1, 1]    1       0 + +
# [1, 0, 1]    0       - 0 -
