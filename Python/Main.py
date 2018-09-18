# import os
# import sys
import random
import warnings
# import time
# import copy
# import psutil

import numpy as np
# import pandas as pd

import matplotlib.pyplot as plt
import seaborn as sns

# from tqdm import tqdm,tqdm_notebook
# from itertools import chain, product

# from skimage.io import imread, imshow, imread_collection, concatenate_images
# from skimage.transform import resize
# from skimage.morphology import label

# from sklearn.model_selection import train_test_split, StratifiedShuffleSplit, StratifiedKFold

# from keras.models import Model, load_model
# from keras.layers import Input,RepeatVector,Reshape,Activation
# from keras.layers.core import Lambda
# from keras.layers.convolutional import Conv2D, Conv2DTranspose, UpSampling2D
# from keras.layers.pooling import MaxPooling2D
# from keras.layers.merge import concatenate
# from keras.callbacks import EarlyStopping, ModelCheckpoint, ReduceLROnPlateau
# from keras import backend as K
# from keras.backend import tf as ktf
from keras.preprocessing.image import ImageDataGenerator
from keras.optimizers import Adam, SGD
# , RMSprop, Adagrad, Adamax, Adadelta, Nadam
# from keras_preprocessing.image import NumpyArrayIterator

# import tensorflow as tf

import Architectures
from Constants import *
import Hyperparameters
import Processing
from Dataset import Dataset
import Testing

plt.style.use('seaborn-white')
sns.set_style("white")

warnings.filterwarnings('ignore', category=UserWarning, module='skimage')

random.seed = SEED
np.random.seed = SEED

# df,train_df = Processing.generate_dataframes()

df,train_df = Processing.load_dataframes()

ds = Dataset(df,train_df)

IDG_fliplr = [True]

IDG_dict = {'vertical_flip':IDG_fliplr}

Augment_dict = {'IDG':[ImageDataGenerator,IDG_dict]}

A = Hyperparameters.Augmentation(Augment_dict)

# UNET_height = [128]
# UNET_width = [128]
# UNET_channels = [1]
# UNET_nfeatures = [1]
UNET_startNumFilters = [4,8,16]
UNET_depth = [3,4,5]
UNET_batchnorm = [True,False]
UNET_dropout = [None,0.1,0.3,0.5]

# UNET_dict = {'IMG_HEIGHT':UNET_height,'IMG_WIDTH':UNET_width,'IMG_CHANNELS':UNET_channels,'n_features':UNET_nfeatures,'start_numFilters':UNET_startNumFilters,'depth':UNET_depth}
UNET_dict = {'start_numFilters':UNET_startNumFilters,'depth':UNET_depth,'batch_norm':UNET_batchnorm,'dropout':UNET_dropout}

Arch_dict = {'UNET':[Architectures.UNET,UNET_dict]}

M = Hyperparameters.Arch(Arch_dict)

SGD_lr = np.logspace(-4,-2,3)
SGD_momentum = [0,0.01,0.1]
SGD_decay = [0,0.01]
SGD_nesterov = [True,False]

SGD_dict = {'lr':SGD_lr,'momentum':SGD_momentum,'decay':SGD_decay,'nesterov':SGD_nesterov}

Adam_lr = np.logspace(-4,-2,3)
Adam_beta1 = [0.8,0.9,0.99]
Adam_beta2 = [0.999]
Adam_decay = [0,0.01]
Adam_amsgrad = [False,True]

Adam_dict = {'lr':Adam_lr,
             'beta_1':Adam_beta1,
             'beta_2':Adam_beta2,
             'decay':Adam_decay,
             'amsgrad':Adam_amsgrad
             }

Opt_dict = {'SGD':[SGD,SGD_dict],
            'Adam':[Adam,Adam_dict]
            }

O = Hyperparameters.Optimizers(Opt_dict)

default_IDG = {k:v[0] for k,v in IDG_dict.items()}
default_IDG['augment'] = ImageDataGenerator

default_UNET = {k:v[0] for k,v in UNET_dict.items()}
default_UNET['arch'] = Architectures.UNET

default_opt = {'opt':Adam,'lr':0.001,'beta_1':0.8,'beta_2':0.999,'decay':0,'amsgrad':False}

default_parameters = {'opt':default_opt,'augment':default_IDG,'arch':default_UNET}

plan = [{'opt':O}]

t = Testing.Trainer(default_parameters)

t.execute(plan,ds,directory='gridsearch2/')
