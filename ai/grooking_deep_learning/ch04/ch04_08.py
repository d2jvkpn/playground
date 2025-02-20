#!/bin/python3

data = 0.5
goal = 0.8
weight = 0.5

for iteration in range(50):
    pred = data * weight
    error = (pred - goal) ** 2
    adjust = (pred - goal) * data # direction and amount
    weight -= adjust

    print("--> Prediction: iteration={}, error={}, prediction={}".format(iteration+1, error, pred))

error = error = (pred - goal) ** 2
print("==> Prediction: weight={}, error={}".format(round(weight, 6), error))
