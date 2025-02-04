#!/bin/python3


data = 0.85
goal = 1.0
weight = 0.1
alpha = 1.0


for iteration in range(10):
  pred = data * weight
  delta = pred - goal
  error = delta ** 2
  weight_delta = delta * data     # 误差缩放
  weight -= weight_delta * alpha  # 负值反转

  print("--> prediction={}, error={}, delta={}, weight_delta={}".format(
    round(pred, 6), round(error, 6), round(delta, 6), round(weight_delta, 6),
  ))
