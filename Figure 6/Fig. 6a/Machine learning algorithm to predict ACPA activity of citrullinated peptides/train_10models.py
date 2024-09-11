import torch
import torch.nn as nn
import torch.nn.functional as F
import torch.optim as optim
from dataset import LandmarkList
from torch.utils import data
from torch.nn.utils.rnn import pack_padded_sequence, pad_packed_sequence
import argparse
import numpy as np

from model import *

#rnn = 'sumGRU'
# rnn = 'crnn'
# rnn = 'cnn'
# rnn = 'GRU'
# rnn = 'embedGRU'
rnn = 'biGRU_ATTEN'
# rnn = 'LSTM'
EMBEDDING_DIM = 10
HIDDEN_DIM = 64
N_LAYERS_RNN = 2
MAX_EPOCH = 60#60
LR = 1e-4
DEVICES = 3
SAVE_BEST_MODEL = True
atten_masks=[
[1,1,1,1,1,1,1,1,1],
[1,1,1,1,1.5,1,1,1,1],
[1,1,1,1.2,1.5,1.2,1,1,1],
[1,1,1,1,2,1,1,1,1],
[1,1,1,1.5,2,1.5,1,1,1],
[1,1,1,1,3,1,1,1,1],
[1,1,1,2,3,2,1,1,1],
[1,1,1,2,4,2,1,1,1],
[1,1,2,4,5,4,2,1,1],
[1,1,2,4,8,4,2,1,1],
]
for test_val_num in range(3,4):
    f1=open('./data4/{}_record_all.txt'.format(test_val_num),'w')

    MODEL_NAME='F'+str(test_val_num)+'final'
    DATASET="0411_9aa_1"
    # train_file='./data4/train_num%d.txt'%(test_val_num)
    # val_file='./data4/test_num%d.txt'%(test_val_num)
    train_file='./data4/train_all.txt'
    val_file='./data4/test_all.txt'

    def compute_binary_accuracy(model, data_loader, loss_function):
        correct_pred, num_examples, correct_pred_pos,correct_pred_neg,recall,total_tp,total_loss = 0, 0, 0,0,0,0,0.

        model.eval()
        with torch.no_grad():

            for batch, labels, lengths in data_loader:

                logits = model(batch.cpu(), lengths)
                total_loss += loss_function(logits, torch.FloatTensor(labels).unsqueeze(1).cpu()).item()
                predicted_labels = (torch.sigmoid(logits) > 0.5).long()
                num_examples += len(lengths)
                correct_pred += (predicted_labels.squeeze(1).cpu().long() == torch.LongTensor(labels).cpu()).sum()

                mask1=predicted_labels.squeeze(1).cpu().long() == torch.LongTensor(labels).cpu()
                mask2=torch.LongTensor(labels).cpu()==1
                mask=[mask1n and mask2n for (mask1n,mask2n) in zip(mask1,mask2) ]
                total_tp+=mask2.sum()
                recall+= torch.LongTensor(mask).sum()

            return correct_pred.float().item()/num_examples * 100, total_loss,recall.float().item()/total_tp.float().item()*100


    def pad_collate(batch):
        batch.sort(key=lambda x: x[2], reverse=True)
        lms, tgs, lens = zip(*batch)
        new_lms = torch.zeros((len(lms), lms[0].shape[0], lms[0].shape[1])) # batch x seq x feature(136)

        #new_lms[0] = torch.from_numpy(lms[0])
        new_lms[0] = lms[0]
        for i in range(1, len(lms)):

            new_lms[i] = torch.cat((lms[i].float(), torch.zeros((lens[0] - lens[i]),EMBEDDING_DIM)), 0)
        return new_lms, tgs, lens

    if rnn == 'frameGRU':
        model = Framewise_GRU_Classifier(EMBEDDING_DIM, HIDDEN_DIM, 1, n_layer=N_LAYERS_RNN)
    if rnn == 'frameCRNN':
        model = FrameCRNN(EMBEDDING_DIM, HIDDEN_DIM, 1, n_layer=N_LAYERS_RNN)
    if rnn == 'sumGRU':
        model = sumGRU(EMBEDDING_DIM, HIDDEN_DIM, 1, n_layer=N_LAYERS_RNN)
    if rnn == 'embedGRU':
        model = embed_GRU_Classifier(EMBEDDING_DIM, HIDDEN_DIM, 1, n_layer=N_LAYERS_RNN)
    if rnn == 'GRU':
        model = GRU_Classifier(EMBEDDING_DIM, HIDDEN_DIM, 1, n_layer=N_LAYERS_RNN)
    if rnn == 'biGRU':
        model = biGRU_Classifier(EMBEDDING_DIM, HIDDEN_DIM, 1, n_layer=N_LAYERS_RNN)
    if rnn == 'biGRU_ATTEN':
        model = biGRU_ATTEN_Classifier(EMBEDDING_DIM, HIDDEN_DIM, 1, n_layer=N_LAYERS_RNN,atten_mask=atten_masks[test_val_num])
    if rnn == 'LSTM':
        model = LSTM_Classifier(EMBEDDING_DIM, HIDDEN_DIM, 1, n_layer=N_LAYERS_RNN)
    if rnn == 'cnn':
        model = cnn_Classifier(EMBEDDING_DIM, HIDDEN_DIM, 1)
    if rnn == 'crnn':
        model = crnn_Classifier(EMBEDDING_DIM, HIDDEN_DIM, 1, n_layer=N_LAYERS_RNN)
    model = model.cpu()

    loss_function = torch.nn.BCEWithLogitsLoss()
    loss_function_eval_sum = torch.nn.BCEWithLogitsLoss(reduction='sum')
    optimizer = optim.Adam(model.parameters(), lr=LR)

    dataset_train = LandmarkList(root='./datasets/', fileList=train_file)
    dataloader_train = data.DataLoader(dataset_train, batch_size=512, shuffle=True, num_workers=0, collate_fn=pad_collate)

    dataset_test = LandmarkList(root='./datasets/', fileList=val_file)
    dataloader_test = data.DataLoader(dataset_test, batch_size=128, shuffle=False, num_workers=0, collate_fn=pad_collate)

    best_test_acc = 0.
    for epoch in range(MAX_EPOCH):
        model.train()
        n_iter = 0
        for batch, labels, lengths in dataloader_train:
            model.zero_grad()
            out = model(batch.cpu(), lengths)  # we could do a classifcation for every output (probably better)
            loss = loss_function(out, torch.FloatTensor(labels).unsqueeze(1).cpu())
            loss.backward()
            optimizer.step()
            n_iter += 1

        train_acc, train_loss, train_recall = compute_binary_accuracy(model, dataloader_train, loss_function_eval_sum)
        test_acc, test_loss,test_recall= compute_binary_accuracy(model, dataloader_test, loss_function_eval_sum)
        print('Epoch{},train_acc,{:.2f}%,train_recall,{:.2f}%,train_loss,{:.8f},valid_acc,{:.2f}%,valid_recall,{:.2f}%,valid_loss,{:.8f}'.format(epoch, train_acc, train_recall,train_loss, test_acc, test_recall,test_loss))
        f1.write('{},{:.2f}%,{:.2f}%,{:.8f},{:.2f}%,{:.2f}%,{:.8f}'.format(epoch, train_acc, train_recall,train_loss, test_acc, test_recall,test_loss)+'\n')
        test_acc=(test_acc+test_recall)/2
        if test_acc > best_test_acc:
            best_test_acc = test_acc
            if SAVE_BEST_MODEL:
                torch.save(model.state_dict(), './models_new4/' + rnn +
                           '_L' + str(N_LAYERS_RNN) +'_'+MODEL_NAME+ '.pt')
            print('best epoch {}, train_acc {}, test_acc {}'.format(epoch, train_acc, test_acc))
    f1.close()