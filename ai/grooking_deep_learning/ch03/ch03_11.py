#!/bin/python3

import numpy as np

def neural_network(data, weights):
    hid = data.dot(weights[0])
    pred = hid.dot(weights[1])

    return pred

# input->hidden: toes % win # fans
ih_wgt = np.array([
  [0.1, 0.2, -0.1], # hid[0]
  [-0.1, 0.1, 0.9], # hid[1]
  [0.1, 0.4, 0.1], # hid[2]
])

# hidden->predication: hid[0], hid[1], hid[2]
hp_wgt = np.array([
  [0.3, 1.1, -0.3], # hurt?
  [0.1, 0.2, -0.0], # win?
  [0.0, 1.3, 0.1], # sad?
]).T

weights = [ih_wgt, hp_wgt]

data = np.array([
  [8.5, 9.5, 9.9, 9.0],  # toes
  [0.65, 0.8, 0.8, 0.9], # wrate
  [1.2, 1.3, 0.5, 1.0],  # nfans
]).T

print("~~~ layers: input, hidden, output")
print()

for d in data:
    pred = neural_network(d, weights)
    print("--> Predications: inputs={}, outputs={}".format(d, pred))
