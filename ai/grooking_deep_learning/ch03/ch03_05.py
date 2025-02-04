#!/bin/python3

import os

def neural_network(d, weights):
  pred = w_sum(d, weights)
  return pred


def w_sum(a, b):
  assert(len(a) == len(b))
  output = 0

  for i in range(len(a)):
    output += a[i] * b[i]

  return output


weights = [0.1, 0.2, 0.0]

toes = [8.5, 9.5, 9.9, 9.0]   # number of toes,                   weights[0]
wlrec = [0.65, 0.8, 0.8, 0.9] # historical win rate (percentage), weights[1]
nfans = [1.2, 1.3, 0.5, 1.0]  # number of fans,                   weights[2]


for i in range(len(toes)):
  d = [toes[i], wlrec[i], nfans[i]]

  pred = neural_network(d, weights)

  print("--> Predication: index={}, input={}, output={:.3f}".format(i, d, pred))


os.sys.exit(0)
