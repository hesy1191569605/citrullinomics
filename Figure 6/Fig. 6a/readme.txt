environment:
python3.6+ubuntu16.04+Intel® Core™ i7-7500U CPU @ 2.70GHz × 4 

data_preprocess: ./python3.6 data_preproscess_new_10sample.py
data_encode: ./python3.6 dataset.py
model_train: ./python3.6 train_10models.py
model_test: ./python3.6 test_10models.py
description of model: ./python3.6 model.py

