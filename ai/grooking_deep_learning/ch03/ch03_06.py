#!/bin/python3


def elementwise_multiplication(vec_a, vec_b):
  assert(len(vec_a) == len(vec_b))

  result = 0
  for i in range(len(vec_a)):
    result += vec_a[i] * vec_b[i]

  return result


def w_sum(a, b):
  assert(len(a) == len(b))
  output = 0

  for i in range(len(a)):
    output += a[i] * b[i]

  return output


a = [0, 1, 0, 1]
b = [1, 0, 1, 0]
c = [0, 1, 1, 0]
d = [0.5, 0, 0.5, 0]
e = [0, 1, -1, 0]

print('''
w_sum(a, b) = 0
w_sum(b, c) = 1
w_sum(b, d) = 1
w_sum(c, c) = 2
w_sum(d, d) = 0.5
w_sum(c, e) = 0
''')

print('''
weights = [1, 0, 1] => if inputs[0] OR inputs[2]
weights = [0, 0, 1] => if inputs[2]
weights = [1, 0, -1] => if inputs[0] OR NOT inputs[2]
weights = [-1, 0, -1] => if NOT inputs[0] OR NOT inputs[2]
weights = [0.5, 0, 1] => if BIG inputs[0] OR inputs[2]
''')
