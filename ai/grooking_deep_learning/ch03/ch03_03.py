#!/bin/python3


def neural_network(d, weight):
    predication = d * weight
    return predication


weight = 0.1

number_of_toes = [8.5, 9.5, 10, 9]
d = number_of_toes[0]

pred = neural_network(d, weight)

print(pred)
