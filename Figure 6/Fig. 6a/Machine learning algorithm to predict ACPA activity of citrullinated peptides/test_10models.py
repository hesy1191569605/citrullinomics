import torch
import torch.nn as nn
import torch.nn.functional as F
import torch.optim as optim
from dataset import LandmarkList, LandmarkListTest,LandmarkListSlipe
from torch.utils import data
from data_preproscess import convert_xlsx_to_txt
from torch.nn.utils.rnn import pack_padded_sequence, pad_packed_sequence
import argparse
import os
from model import *
from sklearn.metrics import roc_curve,auc
import matplotlib.pyplot as plt

rnn = 'biGRU_ATTEN'
dataset_name = 'xxx'

EMBEDDING_DIM = 10
HIDDEN_DIM = 64
N_LAYERS_RNN = 2
DEVICES = 3
atten_masks=[
[1,1,1,1,1,1,1,1,1],
[1,1,1,1,1.5,1,1,1,1],
[1,1,1,1.2,1.5,1.2,1,1,1],
[1,1,1,1,2,1,1,1,1],#test0
[1,1,1,1.5,2,1.5,1,1,1],
[1,1,1,1,3,1,1,1,1],
[1,1,1,2,3,2,1,1,1],# test1
[1,1,1,2,4,2,1,1,1],
[1,1,2,4,5,4,2,1,1],
[1,1,2,4,8,4,2,1,1],
]
SLIP_SIZE = 9
def compute_binary_accuracy_slipe(model, data_loader, th_list,idx_list,seq_list):
    len_th_list = len(th_list)
    correct_pred, num_examples, FP, FN,TP,TN = [0.]*len_th_list, 0, [0]*len_th_list, [0]*len_th_list,[0]*len_th_list, [0]*len_th_list
    FP_list = []
    FN_list = []
    for _ in range(len_th_list):
        FP_list.append([])
        FN_list.append([])
    model.eval()
    count=0
    seq_list_score=[0 for i in range(max(idx_list)+1)]
    label_list=[0]*(max(idx_list)+1)
    max_conf_seq_list=[0 for i in range(max(idx_list)+1)]
    with torch.no_grad():
        for batch, labels, lengths in data_loader:

            logits = model(batch.cpu(), lengths)

            conf=torch.sigmoid(logits)
            if seq_list_score[idx_list[count]]<conf:
                seq_list_score[idx_list[count]] = conf
                max_conf_seq_list[idx_list[count]]=seq_list[count]
            label_list[idx_list[count]] = labels
            count += 1


        num_examples=max(idx_list)+1
        for idx,conf in enumerate(seq_list_score):
            labels = label_list[idx]
            for i, th in enumerate(th_list):
                predicted_labels = (conf > th).long()
                if predicted_labels.squeeze(1).cpu().long() == torch.LongTensor(labels):
                    correct_pred[i] += 1
                    if labels[0]==1:
                        TP[i]+=1
                    else:
                        TN[i]+=1
                elif labels[0] == 0:
                    FP[i] += 1
                    FP_list[i].append(str(labels[0])+'_'+str(torch.sigmoid(logits).squeeze(1).cpu()))
                else:
                    FN[i] += 1
                    FN_list[i].append(str(labels[0])+'_'+str(torch.sigmoid(logits).squeeze(1).cpu()))

        return [n_correct/num_examples * 100 for n_correct in correct_pred], [tp/(tp+fn+0.00001) * 100 for tp,fn in zip(TP,FN)],FP, FN, FP_list, FN_list,seq_list_score,max_conf_seq_list,label_list

def pad_collate(batch):
    batch.sort(key=lambda x: x[2], reverse=True)
    lms, tgs, lens= zip(*batch)
    new_lms = torch.zeros((len(lms), lms[0].shape[0], lms[0].shape[1])) # batch x seq x feature(136)

    new_lms[0] = lms[0]
    for i in range(1, len(lms)):
        new_lms[i] = torch.cat((lms[i].float(), torch.zeros((lens[0] - lens[i]),EMBEDDING_DIM)), 0)
    return new_lms, tgs, lens

def slipe_reader(fileList,txt_new):
    lmList=[]
    idx_list=[]
    count=0
    with open(fileList, 'r') as file:
        for line in file.readlines():
            tmp = line.strip("\n").split(" ")
            lmPath=tmp[0]
            if len(tmp)>1 and len(tmp[-1])==1:
                label_type = tmp[-1]
            else:
                label_type = 0
            if len(lmPath)<=SLIP_SIZE:
                lmList.append((lmPath, int(label_type),lmPath))
                idx_list.append(count)
            else:
                for idx in range(0, len(lmPath) - SLIP_SIZE):
                    seq = lmPath[idx:(SLIP_SIZE + idx)]
                    lmList.append((seq,int(label_type),lmPath))
                    idx_list.append(count)
            count+=1
    f1=open(txt_new, "w+")
    for lm in lmList:
        f1.write("{}".format(lm[0]) + " " +"{}".format(str(lm[1]))+" "+"{}".format(lm[2]) + "\n")
    return idx_list,lmList

def parse_args():
    parser=argparse.ArgumentParser(description='Test sequence')
    parser.add_argument('file_path',default=None,help='the file path to be tested,support txt or xlsx')
    parser.add_argument('--model_path', default=None, help='the path of model')
    parser.add_argument('--thresh',default=[0.8,],help='the conf-thresh of test')
    args=parser.parse_args()
    return args
#./data4/0/8AX8A-1747.xlsx
#AAAAXAAAA-1729.xlsx
#8AX8A-429.xlsx
#AAAAXAAAA-424.xlsx
def main():
    recall_list=[]
    for num in range(3,4):
        model_name = 'F%d' % num +'final'
        args=parse_args()

        #input check
        file_path=args.file_path
        if not os.path.exists(file_path):
            file_path="./data4/AAAAXAAAA-1729.xlsx".format(num)
        # if not os.path.exists(file_path):
        #     print("Test file path not exist,please check input path!")
        #     return
        print(file_path)
        if (".txt" not in file_path) and (".xlsx" not in file_path):
            print("Test file format error,please input xlsx or txt!")
            return

        model_path=args.model_path
        if not model_path:
            #model_path = "models_new/" + str(rnn) + "_L" + str(N_LAYERS_RNN) +'_'+model_name+ ".pt"
            model_path = "models_new4/" + str(rnn) + "_L" + str(N_LAYERS_RNN) +'_'+model_name+ ".pt"
            #model_path = "models_new4/1/" + str(rnn) + "_L" + str(N_LAYERS_RNN) +'_'+model_name+ ".pt"

        if not os.path.exists(model_path):
            print("Test model path not exist,please check input path!")
            return
        else:
            print("Begin to test with model:",model_path)

        thresholds = args.thresh
        if not isinstance(thresholds,list):
            thresholds=[thresholds,]
        for threshold in thresholds:
            if threshold>1 or threshold<0:
            s
                thresholds.pop(threshold)
        if len(thresholds)==0:
            print("Input thresholds all not in (0~1),please check input threshold!")
            return
        if ".xlsx" in file_path:
            txt_ori,valid_idx_list,s_zmy=convert_xlsx_to_txt(file_path,data_row_idx=1,sheet_name=0)
        elif ".txt" in file_path:
            valid_idx_list=None
            txt_ori=file_path


        model = biGRU_ATTEN_Classifier(EMBEDDING_DIM, HIDDEN_DIM, 1, n_layer=N_LAYERS_RNN,atten_mask=atten_masks[num])
        model.load_state_dict(torch.load(model_path))

        aa=torch.load(model_path)

        model = model.cpu()

        txt_new=txt_ori.replace(".txt","_slip_%daa.txt"%SLIP_SIZE)
      
        idx_list,seq_list=slipe_reader(txt_ori,txt_new)

        dataset_test = LandmarkList(root='./datasets/', fileList=txt_new)
        dataloader_test = data.DataLoader(dataset_test, batch_size=1, shuffle=False, num_workers=0,collate_fn=pad_collate)

        test_acc, recall,test_fp, test_fn, test_fp_list, test_fn_list,confs,max_conf_seqs,labels = compute_binary_accuracy_slipe(model, dataloader_test, thresholds,idx_list,seq_list)

        if valid_idx_list:
            assert(sum(valid_idx_list)==len(confs))

        # fpr,tpr,threshold=roc_curve(labels,confs)
        # roc_auc=auc(fpr,tpr)
        # print(roc_auc)
        # plt.figure(figsize=(5,5))
        # plt.plot(fpr,tpr,color='darkorange',lw=2,label='ROC curve(area=%0.2f)'%roc_auc)
        # plt.plot([0,1],[0,1],color="navy",lw=2,dashes=[6,2])
        # plt.xlabel("False Positive Rate")
        # plt.ylabel("True Positive Rate")
        # plt.savefig("./data/1_roc.png")
        # plt.show()

        out_put_file_path=txt_ori.replace(".txt","model{}_test_result.txt".format(num))
        fw=open(out_put_file_path,'w+')
        if valid_idx_list:
            for num,idx in enumerate(valid_idx_list):

                if idx:
                    conf=float(confs[sum(valid_idx_list[:num])])

                    seq=max_conf_seqs[sum(valid_idx_list[:num])]
                    # if conf<0.5:
                    #     if isinstance(s_zmy[num],str):
                    #         if len(s_zmy[num]) == 9:
                    #            print(s_zmy[num],1)
                    #print(round(conf,2),seq[0])
                    #fw.write(seq[0] + ' ' + str(round(conf, 2)) + '\n')
                    if conf > thresholds[0]:
                        fw.write(seq[0]+' '+'1'+'\n')
                    else:
                        fw.write(seq[0] + ' ' + '0' + '\n')
                else:
                    
                    print()
                    a=1

        else:
            for conf,seq in zip(confs,max_conf_seqs):
                conf=float(conf)
                #print(round(conf,2),seq[0])

        recall_list.append(round(test_acc[0],3))
        for i in range(0, len(thresholds)):
            print('\n-----------------Eval for threshold of {:.2f}-------------------'.format(thresholds[i]))

            print('test_acc,{:.3f}%,recall,{:.3f}%,test_fp,{},test_fn,{}'
                  .format(  test_acc[i], recall[i],test_fp[i], test_fn[i]))

            print('Test FP')
            print('total FP',len(test_fp_list[0]))
            # for n in test_fp_list[i]:
            #     print(n)
            print('Test FN')
            print('total FN',len(test_fn_list[0]))
            # for n in test_fn_list[i]:
            #     print(n)
    print(recall_list)

if __name__=='__main__':
    print(torch.__version__)
    main()

