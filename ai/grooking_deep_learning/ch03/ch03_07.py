import numpy as np


def neural_network(data, weights):
  pred = data.dot(weights)
  return pred


weights = np.array([0.1, 0.2, 0])

toes = np.array([8.5, 9.5, 9.9, 9.0])   # number of toes,      weights[0]
wrate = np.array([0.65, 0.8, 0.8, 0.9]) # historical win rate, weights[1]
nfans = np.array([1.2, 1.3, 0.5, 1.0])  # number of fans,      weights[2]

print("~~~ weights: {}".format(weights))
print("~~~ inputs: [number_of_toes, win_rate, number_of_fans]")
print("~~~ output: win")

print()
for i in range(len(toes)):
  d = np.array([toes[i], wrate[i], nfans[i]])
  pred = neural_network(d, weights)

  print("--> Predication: index={}, inputs={}, output={:.3f}".format(i, d, pred))
