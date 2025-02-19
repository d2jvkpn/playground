#!/bin/python3

from sys import stdout, stderr

import numpy as np
from keras.datasets import mnist

#### 1. init
np.random.seed(1)
alpha, iterations, hidden_size, pixels = (0.005, 350, 40, 28*28)

relu = lambda x: (x>=0) * x     # returns x if x > 0, return 0 otherwise
relu2deriv = lambda x: x>=0  # returns 1 for input > 0, return 0 otherwise

def one_hot_labels(labels): # [2] -> [[0, 0, 1, 0, 0, 0, 0, 0, 0, 0]]
    ouput = np.zeros((len(labels),10))

    for i,v in enumerate(labels):
        ouput[i][v] = 1

    return ouput

#### 2. load data
(x_train, y_train), (x_test, y_test) = mnist.load_data()

train_inputs = x_train[0:1000].reshape(1000, pixels) / 255
train_labels = one_hot_labels(y_train[0:1000])

test_inputs = x_test.reshape(len(x_test), pixels) / 255
test_labels = one_hot_labels(y_test)

#### 3. trainning
# layer_0 * weights_0_1 => layer_1 * weights_1_2 => layer_2

print(f"==> parameters: alpha={alpha}, iterations={iterations}, hidden_size={hidden_size}, pixels={pixels}")

weights_0_1 = 0.2*np.random.random((pixels, hidden_size)) - 0.1
weights_1_2 = 0.2*np.random.random((hidden_size, 10)) - 0.1

for j in range(iterations):
    error, correct_cnt, size = (0.0, 0, len(train_inputs))

    for i in range(size):
        layer_0 = train_inputs[i:i+1]
        layer_1 = relu(np.dot(layer_0, weights_0_1))
        layer_2 = np.dot(layer_1, weights_1_2)

        error += np.sum((train_labels[i:i+1] - layer_2) ** 2)
        correct_cnt += int(np.argmax(layer_2) == np.argmax(train_labels[i:i+1]))

        delta_2 = layer_2 - train_labels[i:i+1]  # predication - target
        delta_1 = np.dot(delta_2, weights_1_2.T)  * relu2deriv(layer_1)
        weights_1_2 -= np.dot(layer_1.T, delta_2) * alpha
        weights_0_1 -= np.dot(layer_0.T, delta_1) * alpha

    stdout.write("--> I{:03d}: train_error={:.6f}, train_acc={:.2f}\n".format(j+1, error/size, correct_cnt/size))
    
    if(j % 10 == 0 or j == iterations-1):
        error, correct_cnt, size = (0.0, 0, len(test_inputs))

        for i in range(size):
            layer_0 = test_inputs[i:i+1]
            layer_1 = relu(np.dot(layer_0, weights_0_1))
            layer_2 = np.dot(layer_1, weights_1_2)

            error += np.sum((test_labels[i:i+1] - layer_2) ** 2)
            correct_cnt += int(np.argmax(layer_2) ==  np.argmax(test_labels[i:i+1]))

        stdout.write("    E{:03d}: test_error={:.6f}, test_acc={:.2f}\n".format(j+1, error/size, correct_cnt/size))

print(f"<== weights_0_1[0:3]: {weights_0_1[0:3]}")
print(f"<== weights_1_2[0:3]: {weights_1_2[0:3]}")
