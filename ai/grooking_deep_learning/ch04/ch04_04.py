#!/bin/python3

weight = 0.1
lr = 0.01 # learning rate

def neural_network(data, weight):
    pred = data * weight
    return pred


number_of_toes = [8.5]
win_or_loss_binary = [1] # (won!!!)

pred = neural_network(number_of_toes[0], weight)
error = (pred - win_or_loss_binary[0]) ** 2

print("==> error={:.6f}".format(error))
