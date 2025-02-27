#!/usr/bin/env python3


from sys import stdout, stderr
from datetime import datetime

import numpy as np
import polars as pl
from keras.datasets import mnist

np.random.seed(1)
alpha, iterations = 0.001, 300
hidden_size, number_of_pixels = 100, 28*28

relu = lambda x: (x>=0) * x     # returns x if x > 0, return 0 otherwise
relu2deriv = lambda x: x>=0  # returns 1 for input > 0, return 0 otherwise

def one_hot_labels(labels): # [2] -> [[0, 0, 1, 0, 0, 0, 0, 0, 0, 0]]
    result = np.zeros((len(labels),10))

    for i, v in enumerate(labels):
        result[i][v] = 1

    return result

print()
print(f"==> 1. Parameters: alpha={alpha}, iterations={iterations}, hidden_size={hidden_size}, number_of_pixels={number_of_pixels}")


#### 1. load data
(x_train, y_train), (x_test, y_test) = mnist.load_data()

train_size = 1000
assert(train_size <= len(x_train))
test_size = len(x_test)

train_inputs = x_train[0:train_size].reshape(train_size, number_of_pixels) / 255
train_labels = one_hot_labels(y_train[0:train_size])

test_inputs = x_test[0:test_size].reshape(test_size, number_of_pixels) / 255
test_labels = one_hot_labels(y_test[0:test_size])

#### 2. Trainning the neural network
# Neural Network: layer_0 * weights_0_1 => layer_1 * weights_1_2 => layer_2

weights_0_1 = 0.2*np.random.random((number_of_pixels, hidden_size)) - 0.1
weights_1_2 = 0.2*np.random.random((hidden_size, 10)) - 0.1

t1 = datetime.now().astimezone()
print()
print(f"==> 2. Trainning: start_at={t1.isoformat('T')}, train_size={train_size}, test_size={test_size}")

for n in range(iterations):
    n += 1 # iteration number
    correct_cnt, train_error = 0, 0.0

    for i in range(train_size):
        layer_0 = train_inputs[i:i+1]
        goal = train_labels[i:i+1]

        layer_1 = relu(np.dot(layer_0, weights_0_1))
        dropout_mask = np.random.randint(2, size=layer_1.shape) # [0, 1] 50%
        layer_1 *= (dropout_mask * 2)                                                # [0, 1] * 2 => [0, 2]
        layer_2 = np.dot(layer_1, weights_1_2)

        train_error += np.sum((goal - layer_2) ** 2)
        equals = np.argmax(layer_2, axis=1) == np.argmax(goal, axis=1)
        correct_cnt += np.sum(equals.astype(int))

        delta_2 = layer_2 - goal  # predication - target
        delta_1 = np.dot(delta_2, weights_1_2.T)  * relu2deriv(layer_1)
        delta_1 *= dropout_mask

        weights_1_2 -= np.dot(layer_1.T, delta_2) * alpha
        weights_0_1 -= np.dot(layer_0.T, delta_1) * alpha

    train_error, train_acc = train_error/train_size, correct_cnt/train_size

    if n% 10 == 0 or n == iterations:
        correct_cnt, test_error = 0, 0.0

        for i in range(test_size):
            layer_0 = test_inputs[i:i+1]
            layer_1 = relu(np.dot(layer_0, weights_0_1))
            layer_2 = np.dot(layer_1, weights_1_2)

            test_error += np.sum((test_labels[i:i+1] - layer_2) ** 2)
            if np.argmax(layer_2) ==  np.argmax(test_labels[i:i+1]): correct_cnt += 1

        test_error, test_acc = test_error/test_size, correct_cnt/test_size
        stdout.write(f"--> I{n:03d}: train_error={train_error:.6f}, train_accuracy={train_acc:.3f}, test_error={test_error:.6f}, test_accuracy={test_acc:.3f}\n")

t2 = datetime.now().astimezone()

#### 3. Output the results
print()
print(f"==> 3. Results:")
print(f"    weights_0_1={pl.from_numpy(weights_0_1)}")
print(f"    weights_1_2={pl.from_numpy(weights_1_2)}")

print()
print(f"<== 4. Exit: end_at={t2.isoformat('T')}, elapsed={t2-t1}")
