import random

N,C=500,2
dataset = []
for _ in range(C):
    if random.random() > 0.5:
        c = [random.gauss(5,1) for _ in range(N)]
    else:
        c = [random.uniform(0,100) for _ in range(N)]
    dataset.append(c)

with open("dummy.csv","w") as outf:
    outf.write(f"{N},{C}\n")
    for row in zip(*dataset):
        row_str = "".join(f"{v}," for v in row)[:-1]
        outf.write(f"{row_str}\n")
