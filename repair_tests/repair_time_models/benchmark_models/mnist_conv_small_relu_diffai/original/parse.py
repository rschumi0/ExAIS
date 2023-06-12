import numpy as np
import ast

input = open('mnist_convSmallRELU__DiffAI.pyt', 'r')
lines = input.readlines()

print(len(lines))

for i in range(2):
    wline = 3 + 4 * i
    bline = 4 + 4 * i

    w = np.array(ast.literal_eval(lines[wline]))
    b = np.array(ast.literal_eval(lines[bline]))

    w = w.transpose(3,2,0,1)

    wout = open('w' + str(i + 1) + '.txt', 'w')
    bout = open('b' + str(i + 1) + '.txt', 'w')

    wout.write(str(w.tolist()))
    bout.write(str(b.tolist()))

    wout.flush()
    bout.flush()

    wout.close()
    bout.close()

for i in range(2):
    wline = 10 + 3 * i
    bline = 11 + 3 * i

    w = np.array(ast.literal_eval(lines[wline]))
    b = np.array(ast.literal_eval(lines[bline]))

    print(w.shape)

    wout = open('w' + str(i + 1 + 2) + '.txt', 'w')
    bout = open('b' + str(i + 1 + 2) + '.txt', 'w')

    wout.write(str(w.tolist()))
    bout.write(str(b.tolist()))

    wout.flush()
    bout.flush()

    wout.close()
    bout.close()

input.close()
