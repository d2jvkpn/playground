#!/bin/python3


def neural_network(data, weights):
    pred = w_sum(data, weights)
    return pred


def w_sum(a, b):
    assert(len(a) == len(b))
    output = 0

    for i in range(len(a)):
        output += a[i] * b[i]

    return output

def ele_mul(scalar, vector):
    output = [0.0 for _ in range(len(vector))]

    for i in range(len(vector)):
        output[i] = scalar * vector[i]

    return output

weights = [0.1, 0.2, -0.1]

toes = [8.5, 9.5, 9.9, 9.0]
wrates = [0.65, 0.8, 0.8, 0.9]
nfans = [1.2, 1.3, 0.5, 1.0]

win_or_lose_binary = [1, 1, 0, 1]

goal = win_or_lose_binary[0]
input = [toes[0], wrates[0], nfans[0]]

pred = neural_network(input, weights)

delta = pred - goal
error = delta ** 2
weight_deltas = ele_mul(delta, input)

print("--> 1. pred={}, error={}, weight_deltas={}".format(pred, error, weight_deltas))

alpha = 0.01

print("~~~ 2. origin weights: {}".format(weights))

for i in range(len(weights)):
    weights[i] -= alpha * weight_deltas[i]

print("~~~ 3. updated weights: {}".format(weights))
