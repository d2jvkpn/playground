#!/bin/python3

import numpy as np

np.random.seed(1)

def relu(x):
  return (x > 0) * x

def relu2deriv(output):
  return output > 0

alpha = 0.2
hidden_size = 4

# 6*3
streelights = np.array([
  [1, 0, 1],
  [0, 1, 1],
  [0, 0, 1],
  [1, 1, 1],
  #[0, 1, 1],
  #[1, 0, 1],
])

# 6
walk_vs_stop = np.array([[
  0,
  1,
  0,
  1,
  #1,
  #0,
]]).T


weights_0_1 = 2*np.random.random((3, hidden_size)) - 1
weights_1_2 = 2*np.random.random((hidden_size, 1)) - 1

#layer_0 = streelights[0]
#layer_1 = relu(np.dot(layer_0, weights_0_1))
#layer_2 = relu(np.dot(layer_1, weights_1_2))

for iteration in range(60):
  layer_2_error = 0

  for i in range(streelights.shape[0]):
    layer_0 =  streelights[i:i+1]
    layer_1 = relu(np.dot(layer_0, weights_0_1))
    layer_2 = relu(np.dot(layer_1, weights_1_2))

    #print("--- layer_0={}, layer_1={}, layer_2={}".format(
    #  np.round(layer_0, 3), np.round(layer_1, 3), np.round(layer_2, 3),
    #))

    layer_2_delta = walk_vs_stop[i:i+1] - layer_2
    layer_2_error += np.sum(layer_2_delta ** 2)

    layer_1_delta = layer_2_delta.dot(weights_1_2.T) * relu2deriv(layer_1)

    #print("~~~ {}, {}".format(layer_1.T.shape, layer_2_delta.shape))
    weights_1_2 += alpha * layer_1.T.dot(layer_2_delta)
    weights_0_1 += alpha * layer_0.T.dot(layer_1_delta)

    print("--> weights_0_1={}".format(weights_0_1))
    print("    weights_1_2={}, layer_2_error={}".format(weights_1_2, layer_2_error))
