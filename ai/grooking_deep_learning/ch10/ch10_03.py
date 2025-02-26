#!/usr/bin/env python3


import os
from os import path
from sys import stdout, stderr
from datetime import datetime, timedelta

import yaml
import numpy as np
import polars as pl
from keras.datasets import mnist

random_seed = 1
batch_size = 100
alpha = 2
iterations = 500  # 500, 1000, 2000, 5000

# CNN
image_shape, kernel_shape = (28, 28), (3, 3)
num_kernels =  16
hidden_size = (image_shape[0] - kernel_shape[0]) * (image_shape[1] - kernel_shape[1])  * num_kernels

np.random.seed(random_seed)

tanh = lambda x: np.tanh(x)
tanh2deriv = lambda y: 1 - y**2

def softmax(x):
     val = np.exp(x)
     return val / np.sum(val, axis=1, keepdims=True)

def one_hot_labels(labels): # [2] -> [[0, 0, 1, 0, 0, 0, 0, 0, 0, 0]]
    result = np.zeros((len(labels),10))

    for i, v in enumerate(labels):
        result[i][v] = 1

    return result

def flatten_layer_v1(layer, shape): # matrix(n, 28, 28), tuple(3, 3) -> ??
    sects = list()
    for row in range(layer.shape[1] - shape[0]):
        for col in range(layer.shape[2] - shape[1]):
            sect = layer[:, row:(row+shape[0]), col:(col+shape[1])]
            sects.append(sect.reshape(-1, 1, shape[0], shape[1]))

    expanded_input = np.concat(sects, axis=1)
    es = expanded_input.shape
    result = expanded_input.reshape(es[0] * es[1], -1)
    return result

def format_timedelta(td: timedelta) -> str:
    sign, td = ("-", -td) if td < timedelta(0) else ("", td)
    hours, remainder = divmod(int(td.total_seconds()), 3600)
    minutes, seconds = divmod(remainder, 60)
    return f"{sign}{hours}:{minutes:02}:{seconds:02}.{td.microseconds:06}"

print()
print(f"==> 1. Parameters: random_seed={random_seed}, alpha={alpha}, iterations={iterations}, hidden_size={hidden_size}, num_kernels={num_kernels}")

#### 1. load data
(x_train, y_train), (x_test, y_test) = mnist.load_data() # ~/.keras/datasets/mnist.npz

train_size = min(1000, len(x_train))
test_size = len(x_test)
image = x_train[0]

train_inputs = x_train[0:train_size] / 255
train_labels = one_hot_labels(y_train[0:train_size])

test_inputs = x_test[0:test_size] / 255
test_labels = one_hot_labels(y_test[0:test_size])

#### 2. Trainning the neural network
weights_kernels = 0.02*np.random.random((kernel_shape[0] * kernel_shape[1], num_kernels)) - 0.01 # shape=(9, 16)
weights_1_2 = 0.2*np.random.random((hidden_size, 10)) - 0.1  # range=[-0.1, 0.1], shape=(hidden_size, 10)
trainning_steps = []

t1 = datetime.now().astimezone()
print()
print(f"==> 2. Trainning: start_at={t1.isoformat('T')}, train_size={train_size}, test_size={test_size}")

for n in range(iterations):
    n += 1 # iteration number
    correct_cnt, train_error = 0, 0.0

    for i in range(int(train_size/batch_size)):
        batch_start, batch_end = i * batch_size, (i+1) * batch_size
        layer_0 = train_inputs[batch_start:batch_end] # shape=(100, 28, 28)
        goal = train_labels[batch_start:batch_end] # shape=(100, 10)

        #sects = list()
        #for row in range(layer_0.shape[1] - kernel_shape[0]):
        #    for col in range(layer_0.shape[2] - kernel_shape[1]):
        #        sect = layer_0[:, row:(row+kernel_shape[0]), col:(col + kernel_shape[1])]
        #        sect = sect.reshape(-1, 1, kernel_shape[0], kernel_shape[1])
        #        sects.append(sect)

        #expanded_input = np.concat(sects, axis=1) # shape=(100, 625, 3, 3)
        #es = expanded_input.shape
        #flattened_input =  expanded_input.reshape(es[0]*es[1], -1) # shape=(62500, 9)

        flattened_input = flatten_layer_v1(layer_0, kernel_shape)

        kernel_output = np.dot(flattened_input, weights_kernels)    # shape=(62500, 16)
        layer_1 = tanh(kernel_output.reshape(layer_0.shape[0], -1)) # shape=(100, 10000)

        dropout_mask = np.random.choice([0, 1], size=layer_1.shape, p=[0.5, 0.5]) # np.random.randint(2, size=layer_1.shape)
        layer_1 *= (dropout_mask / 0.5)
        layer_2 = softmax(np.dot(layer_1, weights_1_2)) # shape=(100, 10)

        delta_2 = (layer_2 - goal)  / (layer_0.shape[0] * layer_2.shape[0])
        delta_1 = np.dot(delta_2, weights_1_2.T)  * tanh2deriv(layer_1)
        delta_1 *= dropout_mask

        # no train_error here
        equals = np.argmax(layer_2, axis=1) == np.argmax(goal, axis=1)
        correct_cnt += np.sum(equals.astype(int))

        weights_1_2 -= np.dot(layer_1.T, delta_2) * alpha
        l1d_reshape = delta_1.reshape(kernel_output.shape)
        weights_kernels -= np.dot(flattened_input.T, l1d_reshape) * alpha

    train_acc = correct_cnt/train_size

    if n%10 == 0 or n == iterations-1:
        layer_0, goal = test_inputs, test_labels

        flattened_input = flatten_layer_v1(layer_0, kernel_shape)
        kernel_output = np.dot(flattened_input, weights_kernels)

        layer_1 = tanh(kernel_output.reshape(-1, hidden_size))
        layer_2 = np.dot(layer_1, weights_1_2)

       # no test_error here
        equals = np.argmax(layer_2, axis=1) == np.argmax(goal, axis=1)
        correct_cnt = np.sum(equals.astype(int))
        test_acc = correct_cnt/test_size

        trainning_steps.append((n, train_acc, test_acc))
        stdout.write(f"--> I{n:04d}: train_accuracy={train_acc:.3f}, test_accuracy={test_acc:.3f}\n")

t2 = datetime.now().astimezone()

#### 3. Output the results
os.makedirs("data", mode=511, exist_ok=True)

wts_kernels = pl.from_numpy(weights_kernels)
wts_1_2 = pl.from_numpy(weights_1_2)

trainning_steps = pl.from_records(
  trainning_steps,
  orient="row",
  schema=["iteration", "train_accuracy", "test_accuracy"],
)

parameters = {
  "random_seed": random_seed,
  "batch_size": batch_size,
  "alpha": alpha,
  "iterations": iterations,
  "hidden_size": hidden_size,
  "kernel_shape": kernel_shape,
  "num_kernels": num_kernels,
  "activation_functions": ["tanh", "softmax"],

  "train_size": train_size,
  "test_size": test_size,
  "start_at": t1.isoformat('T'),
  "end_at": t2.isoformat('T'),
  "elapsed": format_timedelta(t2 - t1),
}

wts_kernels.write_csv(path.join("data", "wts_kernels.tsv"), separator='\t')
wts_1_2.write_csv(path.join("data", "wts_1_2.tsv"), separator='\t')
trainning_steps.write_csv(path.join("data", "trainning_steps.tsv"), separator='\t')

with open(path.join("data", "trainning_parameters.yaml"), 'w') as file:
    yaml.safe_dump(parameters, file, sort_keys=False)

print()
print(f"==> 3. Results:")
print(f"    wts_kernels={wts_kernels}")
print(f"    weights_1_2={wts_1_2}")

print()
print(f"<== 4. Exit: elapsed={t2 - t1}")
