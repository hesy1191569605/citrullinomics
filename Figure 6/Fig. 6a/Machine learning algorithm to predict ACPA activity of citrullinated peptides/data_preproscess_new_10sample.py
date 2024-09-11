import pandas as pd
import numpy as np
import os
import random

def cal_max_common_len(str1,str2):
    str1,str2=(str2,str1) if len(str1)>len(str2) else (str1,str2)
    f=[]
    for i in range(len(str1),7,-1):
        for j in range(len(str1)+1-i):
            e=str1[j:j+i]
            if e in str2:
                f.append(len(e))
        if f:
            break
    if len(f)>0:
        f1=max(f)
    else:
        f1=0
    return f1

s_poss=[]
df = pd.read_excel("./data4/1/pos20240411.xlsx")

data_all = df.values
for data in data_all:
    try:
        sequence = data[0].strip()
    except:
        print("skip line {}".format(sequence))
    if len(sequence)!=9:
        print("skip line {}".format(sequence))
        continue
    s_poss.append(sequence)




random.shuffle(s_poss)

s_neg12=[]

df = pd.read_excel("./data4/1/neg20240411.xlsx")

data_all = df.values
for data in data_all:
    try:
        sequence = data[0].strip()
    except:
        print("skip line {}".format(sequence))
    if len(sequence)!=9:
        print("skip line {}".format(sequence))
        continue
    s_neg12.append(sequence)

s_neg3=list(set(s_neg12))
random.shuffle(s_neg3)

s_all=s_poss+s_neg3
import collections
aa=[item for item,count in collections.Counter(s_neg3).items() if count > 1]

s_poss=list(set(s_poss))
s_neg=list(set(s_neg3))

for num in range(10):
    s_pos_test_num=int(len(s_poss)/10)
    s_neg_test_num=int(len(s_neg)/10)

    s_all=s_neg+s_poss

    assert len(s_all)==len(list(set(s_all)))
    s_neg_test=s_neg[num*s_neg_test_num:(num+1)*s_neg_test_num]
    s_neg_train=list(set(s_neg)-set(s_neg_test))
    s_pos_test=s_poss[num*s_pos_test_num:(num+1)*s_pos_test_num]
    s_pos_train=list(set(s_poss)-set(s_pos_test))

    x_over_ratio=int(len(s_neg_train)/(len(s_poss)-len(s_pos_test)))

    s_pos_train_oversample=[]
    # 6 fold oversample
    import random
    for i in range(x_over_ratio):
        s_pos_train_oversample.extend(s_pos_train)
    random.shuffle(s_pos_train_oversample)
    print(len(s_pos_train_oversample))
    print(len(s_neg_train))
    s_pos_test_oversample=[]
    for i in range(x_over_ratio):
        s_pos_test_oversample.extend(s_pos_test)


    f3=open("./data4/1/train_num%d.txt"%num,"w+",encoding='utf-8')
    for pos in s_pos_train_oversample:
        if len(pos) != 9:
            print(pos)
            continue
        f3.write("{} 1\n".format(pos))
    for pos in s_neg_train[:-1]:
        if len(pos)!=9:
            print(pos)
            continue
        f3.write("{} 0\n".format(pos))
    f3.write("{} 0".format(s_neg_train[-1]))

    f3=open("./data4/1/test_num%d.txt"%num,"w+",encoding='utf-8')
    for pos in s_pos_test_oversample:
        if len(pos)!=9:
            print(pos)
            continue
        f3.write("{} 1\n".format(pos))

    for pos in s_neg_test[:-1]:
        if len(pos)!=9:
            print(pos)
            continue
        f3.write("{} 0\n".format(pos))
    f3.write("{} 0".format(s_neg_test[-1]))