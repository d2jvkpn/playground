#!/bin/python3

import sys

import numpy as np
from keras.datasets import mnist

#### 1.
(x_train, y_train), (x_test, y_test) = mnist.load_data()

# images, labels = (x_train[0:1000].reshape(1000, 28*28) / 255, y_train[0:1000])
images = x_train[0:1000].reshape(1000, 28*28) / 255
labels = y_train[0:1000]
one_hot_labels = np.zeros((len(labels), 10))

test_images = x_test.reshape((len(x_test), 28*28)) / 255
test_labels = np.zeros((len(y_test), 10))

for i, l in enumerate(labels):
  one_hot_labels[i][1] = 1

labels = one_hot_labels

#### 2.
np.random.seed(1)
relu = lambda x: (x>=0) * x
relu2deriv = lambda x: x>=0

alpha, iterations, hidden_size, pixels_per_image, num_labels = (0.005, 350, 40, 28*28, 10)

#### 3.
w0 = 0.2*np.random.random((pixels_per_image, hidden_size)) - 0.1  # weights_0_1
w1 = 0.2*np.random.random((hidden_size, num_labels)) - 0.1            # weights_1_2

for j in range(iterations):
  error, correct_cnt = (0.0, 0)

  for i in range(len(images)):
    l0 = images[i:i+1]            # layer 0: input layer
    l1 = relu(np.dot(l0, w0))  # layer 1: hidden layer
    l2 = relu(np.dot(l1, w1))  # layer 2: output layer
    error += np.sum(labels[i:i+1] - l2) ** 2
    correct_cnt += int(np.argmax(l2) == np.argmax(labels[i:i+1]))

    d2 = (labels[i:i+1] - l2)                      # layer 2 delta
    d1 = d2.dot(w1.T) * relu2deriv(l1)  # layer 1 delta

    w1 += l1.T.dot(d2) * alpha
    w0 += l0.T.dot(d1) * alpha

  sys.stdout.write("--> I{:03d}: error={:.6f}, correct={:.2f}\n".format(j, error/len(images), correct_cnt/(len(images))))
