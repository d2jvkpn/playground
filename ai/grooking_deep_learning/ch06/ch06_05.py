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

# 6*1
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

input = streelights[0]
goal = walk_vs_stop[0]

for i in range(20):
  pred = input.dot(weights)
  delta = pred - goal
  error = delta ** 2
  weights -= (input * delta) * alpha

  print("--> {}: error={};\tprediction={};\tweights={}".format(
    i+1, np.round(error, 6), np.round(pred, 6), np.round(weights, 6),
  ))
