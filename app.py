import random
for _ in range(13):
    str_=""
    for _ in range(6):
        str_+=f"{random.randint(1,100)} "
    print(str_)
    print("\n")
