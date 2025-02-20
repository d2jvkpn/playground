#!/bin/python3


weight = 0.5
goal = 0.8
data = 2.0
alpha = 0.1 # 1.0, 0.1, 0.01, 0.001, 0.0001


for iteration in range(20):
    pred = data * weight
    delta = pred - goal
    error = delta ** 2
    derivative = data * delta
    weight -= derivative * alpha

    print("--> prediction={}, error={}, weight={}".format(round(pred, 6), round(error, 6), round(weight, 6)))
