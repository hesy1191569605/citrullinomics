from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import torch.utils.data as data
import pandas as pd
import numpy as np
import os
import os.path
import re
import torch
import pickle


def default_transform(sequence,feature_dict,normalize):
    feature_map = []
    # if len(sequence) != 16:
    #     continue
    for char in sequence:
        try:
            feature_map.append(feature_dict[char])
        except:
            continue
    feature_array = np.array(feature_map)
    data = FNormalizeMult(feature_array, normalize)
    data=torch.from_numpy(data)
    return data

def slipe_transform(sequence,feature_dict,normalize,slipe_size=16):
    feature_map = []
    if len(sequence) <= slipe_size:
        for char in sequence:
            try:
                feature_map.append(feature_dict[char])
            except:
                continue
        feature_array = np.array(feature_map)
        data = FNormalizeMult(feature_array, normalize)
        data=torch.from_numpy(data)
        return [data],[sequence]
    else:
        data_ist=[]
        seq_list=[]
        for idx in range(0,len(sequence)-slipe_size):
            seq=sequence[idx:(slipe_size+idx)]
            for char in seq:
                try:
                    feature_map.append(feature_dict[char])
                except:
                    continue
            feature_array = np.array(feature_map)
            data = FNormalizeMult(feature_array, normalize)
            data=torch.from_numpy(data)
            data_ist.append(data)
            seq_list.append(seq)
        return data_ist,seq_list


def FNormalizeMult(data,normalize):
    data = np.array(data)
    for i in range(0, data.shape[1]):
        listlow = normalize[i, 0]
        listhigh = normalize[i, 1]
        delta = listhigh - listlow
        if delta != 0:
            
            data[:, i] = (data[:, i] - listlow) / delta
    return data


def default_loader(path):
    return

def slipe_list_reader(fileList,slipe_size=16):
    lmList = []
    
    with open(fileList, 'r') as file:
        for line in file.readlines():
            tmp = line.strip("\n").split(" ")
            lmPath=tmp[0]
            label_type = tmp[-1]
            if len(lmPath)<=slipe_size:
                lmList.append((lmPath, int(label_type),lmPath))

            else:

                for idx in range(0, len(lmPath) - slipe_size):
                    seq = lmPath[idx:(slipe_size + idx)]
                    lmList.append((seq,int(label_type),lmPath))
    return lmList


def default_list_reader(fileList):
    lmList = []
    
    with open(fileList, 'r') as file:
        for line in file.readlines():
            tmp = line.strip("\n").split(" ")
            lmPath=tmp[0]
            label_type = tmp[1]
            try:
                lmList.append((lmPath, int(label_type)))
            except:
                print()
    return lmList




class LandmarkListTest(data.Dataset):
    def __init__(self, root, fileList, transform=None, list_reader=default_list_reader, loader=default_loader):
        self.root      = root
        self.lmList   = list_reader(fileList)
        self.transform = transform
        self.loader    = loader
        data_dict = {
 'citrulline': 'X',
 'Glycine': 'G',
 'Alanine': 'A',
 'Valine': 'V',
 'Leucine': 'L',
 'Isoleucine': 'I',
 'Phenylalanine': 'F',
 'Tryptophan': 'W',
 'Tyrosine': 'Y',
 'Aspartate': 'D',
 'Glutamate': 'E',
 'Lysine': 'K',
 'Asparagine': 'N',
 'Glutamine': 'Q',
 'Methionine': 'M',
 'Serine': 'S',
 'Threonine': 'T',
 'Cysteine': 'C',
 'Proline': 'P',
 'Histidine': 'H',
 'Arginine': 'R'
}
        df = pd.read_excel("./data/21-amino-acid.xlsx")
        data = df.values
        feature_dict = {}
        for value in data:
            name = value[0]
            fea_list = []
            for fea in value[1:]:
                fea_list.append(float(fea))
            char = data_dict[name]
            feature_dict[char] = fea_list

        self.feature_dict = feature_dict

    def __getitem__(self, index):
        lm, target = self.lmList[index]
        # lm = self.loader(Sequence)
        lm = self.transform(lm,self.feature_dict,self.normalize)
        return lm, target, lm.shape[0]

    def __len__(self):
        return len(self.lmList)