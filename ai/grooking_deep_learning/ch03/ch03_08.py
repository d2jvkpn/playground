#!/bin/python3

# one input => multiply outputs

def neural_network(data, weights):
    pred = ele_mul(data, weights)
    return pred


def ele_mul(number, vector):
    output = [0.0 for _ in range(len(vector))] # [hurt, win, sad]

    for i in range(len(vector)):
        output[i] = round(number * vector[i], 3)

    return output


weights = [0.3, 0.2, 0.9]
wrate = [0.65, 0.8, 0.8, 0.9] # historical win rate, weights[1]

print("~~~ weights: {}".format(weights))
print("~~~ input: win_rate")
print("~~~ outputs: [hurt, win, sad]")

print()
for i in range(len(wrate)):
    preds = neural_network(wrate[i], weights)
    print("--> Predication: index={}, input={:.3f}, predications={}".format(i, wrate[i], preds))
