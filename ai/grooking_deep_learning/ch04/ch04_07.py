#!/usr/bin/env python3


data = 0.5
goal = 0.8

weight = 0.5
step_amount = 0.001

for iteration in range(1101):
    pred = data * weight
    error = (pred - goal) ** 2

    print("--> Prediction: iteration={}, error={}, prediction={}".format( iteration+1, error, pred))

    pred = data * (weight + step_amount)
    err_up = (pred - goal) ** 2

    pred = data * (weight - step_amount)
    err_down = (pred - goal) ** 2

    if error <= err_up and error <= err_down:
        break

    if (err_down < err_up):
        weight -= step_amount

    if (err_down > err_up):
        weight += step_amount

error = error = (pred - goal) ** 2
print("==> Prediction: weight={}, error={}".format(round(weight, 6), error))
