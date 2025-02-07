#!/bin/python3


# inputs: array[m]
# weights: matrix[n, m]
# predications: array[n]

# array[M] * array[M] -> scalar
def w_sum(a, b):
  assert(len(a) == len(b))
  output = 0

  for i in range(len(a)):
    output += a[i] * b[i]

  return output


# array[M] * matrix[M, M] = array[M]
def vect_mat_mul(vect, matrix):
  assert(len(matrix) > 0 and len(vect) == len(matrix[0]))
  output = [0.0 for _ in range(len(matrix))]

  for i in range(len(matrix)):
    output[i] = w_sum(vect, matrix[i])

  return output


def neural_network(data, weights):
  pred = vect_mat_mul(data, weights)
  return pred


def outer_prod(vec_a, vec_b):
  out = [[0.0 for _ in range(len(vec_b))] for _ in range(len(vec_a))]

  for i in range(len(vec_a)):
    for j in range(len(vec_b)):
      out[i][j] = vec_a[i] * vec_b[j]

  return out


# toes %win fans
weights = [
  [0.1, 0.1, -0.3], # hurt?
  [0.1, 0.2, 0.0],  # win?
  [0.0, 1.3, 0.1],  # sad?
]

# inputs
toes =   [8.5,  9.5, 9.9, 9.0]
wrates = [0.65, 0.8, 0.8, 0.9]
nfans =  [1.2,  1.3, 0.5, 1.0]

# output
hurt = [0.1, 0.0, 0.0, 0.1]
win =  [1.0, 1.0, 0.0, 1.0]
sad =  [0.1, 0.0, 0.1, 0.2]

alpha = 0.01

inputs = [toes[0], wrates[0], nfans[0]]
goal = [hurt[0], win[0], sad[0]]

error =  [0.0 for _ in range(len(goal))] # number of pred
deltas = [0.0 for _ in range(len(goal))] # number of pred

#### 1.
pred = neural_network(inputs, weights)

for i in range(len(goal)):
  deltas[i] = pred[i] - goal[i]
  error[i] = deltas[i] ** 2

print("==> 1. deltas={}\n    error={}, {}".format(deltas, error, sum(error)))

# array[m, n], m is dim of inputs, n is dim of pred
weight_deltas = outer_prod(inputs, deltas)

print("--> weights={}".format(weights))

print("--> weight_deltas={}".format(weight_deltas))

for i in range(len(goal)):
  for j in range(len(inputs)):
    weights[i][i] -= weight_deltas[i][j] * alpha

print("--> weights={}".format(weights))

#### 2.
pred = neural_network(inputs, weights)

for i in range(len(goal)):
  deltas[i] = pred[i] - goal[i]
  error[i] = deltas[i] ** 2

print("==> 2. deltas={}\n    error={}, {}".format(deltas, error, sum(error)))

# array[m, n], m is dim of inputs, n is dim of pred
weight_deltas = outer_prod(inputs, deltas)

print("--> weights={}".format(weights))

print("--> weight_deltas={}".format(weight_deltas))

for i in range(len(goal)):
  for j in range(len(inputs)):
    weights[i][i] -= weight_deltas[i][j] * alpha

print("--> weights={}".format(weights))
