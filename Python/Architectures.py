from keras.layers import Input,RepeatVector,Reshape, BatchNormalization
from keras.layers.core import Lambda, Dropout
from keras.layers.convolutional import Conv2D, Conv2DTranspose, UpSampling2D
from keras.layers.pooling import MaxPooling2D
from keras.layers.merge import concatenate

from keras.models import Model, load_model

from keras.backend import tf as ktf
from keras.utils import plot_model

import Constants

import collections

import Loss_functions


class UNET:
    
    def __init__(self,model=None,**kwargs):
        
        if len(kwargs) > 0:
            
            self.model = UNET.from_parameters(**kwargs)
            
        else:
        
            self.model = model
    
    def from_parameters(n_features=1,IMG_HEIGHT=128,IMG_WIDTH=128,IMG_CHANNELS=1,start_numFilters=8,depth=5,use_features=True,model_filename=None,asc_mode=None,dropout=None,batch_norm=False,dropout_mode='full',initializer='glorot_uniform'):
        
        inputs = Input((IMG_HEIGHT,IMG_WIDTH,IMG_CHANNELS), name='img')

        if isinstance(dropout,collections.Mapping):

            dropout_desc = dropout.get('desc',None)
            dropout_asc = dropout.get('asc',None)
            dropout_final = dropout.get('final',None)

        elif dropout_mode == 'paper':

            dropout_final = dropout_asc = None
            dropout_desc = dropout

        else:

            dropout_desc = dropout_asc = dropout_final = dropout

        if isinstance(batch_norm,collections.Mapping):

            batchn_desc = batch_norm.get('desc',False)
            batchn_asc = batch_norm.get('asc',False)

        else:

            batchn_desc = batchn_asc = batch_norm
        
        if use_features:
        
            input_features = Input((n_features, ), name='feat')
        
        last = Lambda(lambda x:x / 255)(inputs)
        numFilters = start_numFilters
        
        conv_desc = []
        
        for i in range(depth):
            
            if dropout_mode == 'paper' and i < depth - 1:

                c,last = UNET.create_desc_layers(last,numFilters,None,batchn_desc)

            else:
                
                c,last = UNET.create_desc_layers(last,numFilters,dropout_desc,batchn_desc)
            
            conv_desc.append(c)
            
            numFilters *= 2
            
        if use_features:
            
            last = UNET.create_feat_layers(last,IMG_HEIGHT,IMG_WIDTH,depth,input_features,n_features)
            
        conv_desc = conv_desc[::-1]
        
        for i in range(depth):
            
            if asc_mode == 'resize_conv':
                
                height = IMG_HEIGHT // (2**(depth - i))
                width = IMG_WIDTH // (2**(depth - i))
                last = UNET.create_asc_layers_resize_conv(last,conv_desc[i],numFilters,(height,width),dropout_asc,batchn_asc)
                
            else:
                
                last = UNET.create_asc_layers(last,conv_desc[i],numFilters,dropout_asc,batchn_asc)
            
            numFilters //= 2
            
        outputs = UNET.create_output_layers(last,numFilters,dropout_final)
        
        model = Model(inputs=[inputs,input_features], outputs=[outputs])
        
        return model
    
    def from_filename(filename,custom_objects,**kwargs):
        
        model = load_model(filename, custom_objects=custom_objects, **kwargs)

        return UNET(model)
        
    def save_model(self,filename=None):
        
        if filename is None:
            
            if self.model_filename is None:
                
                raise ValueError('No filename specified')
                
            else:
                
                self.model.save(self.model_filename)
                
        else:
            
            self.model.save(filename)
            
    def load_model(self,filename=None):
        
        if filename is None:
            
            if self.model_filename is None:
                
                raise ValueError('No filename specified')
                
            else:
                
                self.model = load_model(filename, custom_objects={'mean_iou': Loss_functions.mean_iou})
                
    def save_weights(self,filename):
        
        self.model.save_weights(filename)
        
    def get_model(self):
        
        return self.model
        
    def plot_model(self,filename='model.png',**kwargs):
        
        plot_model(self.model, to_file=filename, **kwargs)
        
    def create_feat_layers(lastLayer,IMG_HEIGHT,IMG_WIDTH,depth,input_features,n_features):
        
        final_height = IMG_HEIGHT // (2**depth)
        final_width = IMG_WIDTH // (2**depth)
            
        f_repeat = RepeatVector(final_height * final_width)(input_features)
        f_conv = Reshape((final_height, final_width, n_features))(f_repeat)
        last = concatenate([lastLayer, f_conv], -1)
        
        return last
        
    def create_output_layers(lastLayer,numFilters,dropout,filterSize=(3,3),activation='relu',padding='same',activation_output='sigmoid'):

        last = Conv2D(numFilters, (3, 3), activation=activation, padding=padding)(lastLayer)
        last = Conv2D(numFilters, (3, 3), activation=activation, padding=padding)(last)

        if dropout is not None:

            last = Dropout(dropout,seed=Constants.SEED)(last)

        outputs = Conv2D(1, (1, 1), activation='sigmoid')(last)
        
        return outputs
        
    def create_desc_layers(startLayer,numFilters,dropout,batch_norm,filtersize=(3,3),activation='relu',padding='same',initializer='glorot_uniform'):
            
        c = Conv2D(numFilters, filtersize, activation=activation, padding=padding, kernel_initializer=initializer)(startLayer)
        
        if batch_norm:

            c = BatchNormalization()(c)

        c = Conv2D(numFilters, filtersize, activation=activation, padding=padding, kernel_initializer=initializer)(c)

        if batch_norm:

            c = BatchNormalization()(c)

        if dropout is not None:

            c = Dropout(dropout,seed=Constants.SEED)(c)

        p = MaxPooling2D((2, 2))(c)

        return (c,p)

    def create_asc_layers(startLayer,concatLayer,numFilters,dropout,batch_norm,filtersize=(3,3),activation='relu',padding='same',numFilters_tconv=None,filtersize_tconv=(2,2),stride_tconv=(2,2),padding_tconv='same',initializer='glorot_uniform'):
    
        if numFilters_tconv is None:

            numFilters_tconv = numFilters // 2

        c = Conv2D(numFilters, filtersize, activation=activation, padding=padding, kernel_initializer=initializer)(startLayer)

        if batch_norm:

            c = BatchNormalization()(c)

        c = Conv2D(numFilters, filtersize, activation=activation, padding=padding, kernel_initializer=initializer)(c)

        if batch_norm:

            c = BatchNormalization()(c)

        if dropout is not None:

            c = Dropout(dropout,seed=Constants.SEED)(c)

        t = Conv2DTranspose(numFilters_tconv, filtersize_tconv, strides=stride_tconv, padding=padding_tconv, kernel_initializer=initializer)(c)
        t = concatenate([t,concatLayer])
    
        return t
    
    def create_asc_layers_resize_conv(startLayer,concatLayer,numFilters,resize_size,dropout,batch_norm,filtersize=(3,3),activation='relu',padding='same',numFilters_conv=None,filterSize_conv=(3,3),padding_conv='same',initializer='glorot_uniform'):
        
        # if numFilters_conv is None:
            
        #     numFIlters_conv = numFilters // 2
            
        c = Conv2D(numFilters, filtersize, activation=activation, padding=padding, kernel_initializer=initializer)(startLayer)

        if batch_norm:

            c = BatchNormalization()(c)

        c = Conv2D(numFilters, filtersize, activation=activation, padding=padding, kernel_initializer=initializer)(c)

        if batch_norm:

            c = BatchNormalization()(c)

        if dropout is not None:

            c = Dropout(dropout,seed=Constants.SEED)(c)
        
        t = Lambda(lambda image: ktf.image.resize_images(image, resize_size))(c)
        t = Conv2D(numFilters_conv, filterSize_conv, padding=padding_conv, kernel_initializer=initializer)(c)
        t = concatenate([t,concatLayer])


class ATROUS:

    def __init__(self,model=None,**kwargs):

        if len(kwargs) > 0:
            
            self.model = ATROUS.from_parameters(**kwargs)
            
        else:
        
            self.model = model

    def from_parameters():

#        TODO : GENERATE ATROUS NETWORK FROM PARAMETERS
        NOTHING_TO_SEE_HERE = 42
