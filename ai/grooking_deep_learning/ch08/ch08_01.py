#!/usr/bin/env python3

from sys import stdout, stderr

import numpy as np
from keras.datasets import mnist

#### 1. init
np.random.seed(1)
alpha, iterations, hidden_size, number_of_pixels = (0.005, 350, 40, 28*28)

relu = lambda x: (x>=0) * x     # returns x if x > 0, return 0 otherwise
relu2deriv = lambda x: x>=0  # returns 1 for input > 0, return 0 otherwise

def one_hot_labels(labels): # [2] -> [[0, 0, 1, 0, 0, 0, 0, 0, 0, 0]]
    ouput = np.zeros((len(labels),10))

    for i,v in enumerate(labels):
        ouput[i][v] = 1

    return ouput

#### 2. load data
(x_train, y_train), (x_test, y_test) = mnist.load_data()

train_inputs = x_train[0:1000].reshape(1000, number_of_pixels) / 255
train_labels = one_hot_labels(y_train[0:1000])

test_inputs = x_test.reshape(len(x_test), number_of_pixels) / 255
test_labels = one_hot_labels(y_test)

#### 3. trainning
# Neural Network: layer_0 * weights_0_1 => layer_1 * weights_1_2 => layer_2
print(f"==> Parameters: alpha={alpha}, iterations={iterations}, hidden_size={hidden_size}, number_of_pixels={number_of_pixels}")

weights_0_1 = 0.2*np.random.random((number_of_pixels, hidden_size)) - 0.1
weights_1_2 = 0.2*np.random.random((hidden_size, 10)) - 0.1
train_size, test_size = len(train_inputs), len(test_inputs)

for n in range(iterations):
    n += 1 # iteration number
    correct_cnt, train_error = 0, 0.0

    for i in range(train_size):
        layer_0 = train_inputs[i:i+1]
        layer_1 = relu(np.dot(layer_0, weights_0_1))
        layer_2 = np.dot(layer_1, weights_1_2)

        train_error += np.sum((train_labels[i:i+1] - layer_2) ** 2)
        if np.argmax(layer_2) == np.argmax(train_labels[i:i+1]): correct_cnt+=1

        delta_2 = layer_2 - train_labels[i:i+1]  # predication - target
        delta_1 = np.dot(delta_2, weights_1_2.T)  * relu2deriv(layer_1)
        weights_1_2 -= np.dot(layer_1.T, delta_2) * alpha
        weights_0_1 -= np.dot(layer_0.T, delta_1) * alpha

    train_error, train_acc = train_error/train_size, correct_cnt/train_size
    # stdout.write(f"--> I{n:03d}: train_error={train_error:.6f}, train_acc={train_acc:.3f}\n")

    if n% 10 == 0 or n == iterations-1:
        correct_cnt, test_error = 0, 0.0

        for i in range(test_size):
            layer_0 = test_inputs[i:i+1]
            layer_1 = relu(np.dot(layer_0, weights_0_1))
            layer_2 = np.dot(layer_1, weights_1_2)

            test_error += np.sum((test_labels[i:i+1] - layer_2) ** 2)
            if np.argmax(layer_2) ==  np.argmax(test_labels[i:i+1]): correct_cnt += 1

        test_error, test_acc = test_error/test_size, correct_cnt/test_size
        stdout.write(f"--> I{n:03d}: train_error={train_error:.6f}, train_acc={train_acc:.3f}, test_error={test_error:.6f}, test_acc={test_acc:.3f}\n")

print("<== Results:")
print(f"    weights_0_1[0:3]: {weights_0_1[0:3]}")
print(f"    weights_1_2[0:3]: {weights_1_2[0:3]}")
