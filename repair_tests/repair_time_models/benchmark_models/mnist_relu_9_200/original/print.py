import numpy as np
import ast

input = open('mnist_relu_9_200.tf', 'r')
lines = input.readlines()

print(len(lines))

for i in range(len(lines)):
    line = lines[i]
    output = open('output' + str(i) + '.txt', 'w')
    output.write(line)
    output.flush()
    output.close()

input.close()
