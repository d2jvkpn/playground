#!/usr/bin/env python3


import numpy as np

def neural_network(data, weights):
    pred = vect_mat_mul(data, weights)
    return pred

def w_sum(a, b):
    assert(len(a) == len(b))
    output = 0

    for i in range(len(a)):
        output += a[i] * b[i]

    return output

def vect_mat_mul(vect, matrix):
    assert(len(vect) == len(matrix))
    output = [0.0 for _ in range(len(vect))]

    for i in range(len(matrix)):
        output[i] = w_sum(vect, matrix[i])

    # [hurt, win, sad]
    return [round(float(v), 3) for v in output]


# toes % win # fans
weights = [
  [0.1, 0.1, -0.3], # hurt?
  [0.1, 0.2, 0.0],  # win?
  [0.0, 1.3, 0.1],  # sad?
]

toes = [8.5, 9.5, 9.9, 9.0]   # number of toes,      weights[0]
wrates = [0.65, 0.8, 0.8, 0.9] # historical win rate, weights[1]
nfans = [1.2, 1.3, 0.5, 1.0]  # number of fans,      weights[2]

print("~~~ weights: {}".format(weights))
print("~~~ inputs: [number_of_toes, win_rate, number_of_fans]")
print("~~~ inputs: [hurt, win, sad]")

print()
for i in range(len(toes)):
    d = np.array([toes[i], wrates[i], nfans[i]])
    pred = neural_network(d, weights)

    print("--> Predication: index={}, inputs={}, outputs={}".format(i, d, pred))
