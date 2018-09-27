from keras.callbacks import EarlyStopping, ReduceLROnPlateau
from keras import backend as K
from itertools import product
import psutil
import time
import Loss_functions
import numpy as np
import pandas as pd
from matplotlib import pyplot as plt
import gc
import os


class Trainer:
    
    def __init__(self,default_parameters):
        
        self.expected_parameters = ['opt','arch','augment']
        
        if not(set(self.expected_parameters).issubset([*default_parameters])):
            
            raise ValueError('Missing default parameters')
        
        self.default_parameters = default_parameters
        self.defaults_names = {k:v[k].__name__ + ("-{}" * (len(v) - 1)).format(*[w for l,w in v.items() if l != k]) for k,v in default_parameters.items()}
        
        self.defaults = {k:Trainer.instanciate(v,k) for k,v in default_parameters.items()}
        print(self.defaults)
        self.defaults['arch'].save_weights('weights_default.hp5')
        
    def execute(self,plan,dataset,batch_size=16,directory="gridsearch/",n_splits=1,update_best_para=False,resume=False):

        if resume:

            files = [f for f in os.listdir(directory)]

            start_i = max(len(files) - 1,0)

        else:

            start_i = 0

        print(f"start_i = {start_i}")

        n = len(plan)
        
        reduceLR = ReduceLROnPlateau(patience=5, verbose=0, factor=0.1)
        earlystopper = EarlyStopping(patience=10, verbose=0, min_delta=0.005)
        
        # index = pd.MultiIndex(levels=[[],[]],
        #                       labels=[[],[]],
        #                       names=[u'plans', u'id'])
        
        df_temp_list = []

        # memory_used = []
        
        for i in range(start_i,n):

            if resume and (i == start_i) and len(files) > 0:

                df = pd.read_pickle(directory + f'temp{i}.pkl')
                start_j = len(df.index)

            else:

                start_j = 0

            print(f"start_j = {start_j}")

            print(f"step {i}")
            
            keys = [*plan[i]]
            defaults = [k for k in self.expected_parameters if k not in keys]
            
            dfs = [P.get_df() for P in plan[i].values()]
            
            if len(keys) == 1:
                
                index = [np.arange(len(dfs[0]))]
                
            else:
                
                lengths = [len(df) for df in dfs]

                a = np.array([*product(*lengths)])
                index = [a[:,i] for i in range(a.shape[1])]

            df_temp = pd.DataFrame()
            
            params_df = {k:plan[i][k].get_df() for k in keys}
            print(len(params_df))

            if start_j == len(index[0]):

                bypass_first_time = True

            else:

                bypass_first_time = False
            
            for j in range(start_j,len(index[0])):

                print(f'beginning parameter combination {j}')
                
                # index_dict = {keys[i]:index[i][j] for i in range(len(keys))}
                
                # parameters = copy.deepcopy(self.defaults)
                parameters = {k:v for k,v in self.defaults.items() if k in defaults}
        
                # names_dict = copy.deepcopy(self.defaults_names)
                names_dict = {k:v for k,v in self.defaults_names.items() if k in defaults}

                # if update_best_para:

                #     new_best_parameters = {k:v for k,v in self.defaults.items() if k in self.default_parameters}
                #     best_loss = np.inf
                
                for k in keys:
                    
                    pdf = params_df[k]
                    param = pdf.loc[j,k]

                    # x = pdf.loc[j,pdf.columns.difference([k+'_name',k])].dropna().to_dict()
        
                    parameters[k] = param(**pdf.loc[j,pdf.columns.difference([k + '_name',k])].dropna().to_dict())
                    names_dict[k] = pdf.loc[j,k + '_name']
                
                name = ""
                
                for s in [names_dict[k] for k in self.expected_parameters]:
                    
                    name += s + '_'
                
                name = name[:-1]
                # filename = directory + name + '.hp5'
                
                l = [params_df[e].loc[j] if e in keys else pd.Series(self.default_parameters[e]) for e in self.expected_parameters]
                line = pd.concat(l)
#                 line['name'] = name

                model = parameters['arch'].get_model()
    
                if 'arch' in keys:
        
                        model.save_weights('weights_temp.hp5')
            
                cpu_time_list,min_val_loss_list,mean_iou_list,final_val_loss_list,final_lr_list,number_epochs_list = [],[],[],[],[],[]
                
                for X_train,X_feat_train,Y_train,X_val,X_feat_val,Y_val,X_test,X_feat_test in dataset.sss(n_splits=n_splits,test_size=0.1):
            
                    if 'augment' not in keys and psutil.virtual_memory().percent >= 90:
                    
                        print('oom')
                        v = self.default_parameters['augment']
                        self.defaults['augment'] = v['augment'](**{l:w for l,w in v.items() if l != 'augment'})
                    
                    parameters['augment'].fit(X_train)
                    # gen_flow = parameters['augment'].flow((X_train,X_feat_train),Y_train,batch_size=batch_size)
                
#                   checkpointer = ModelCheckpoint(filename, verbose=0, save_best_only=True)
                
                    # clock_time = time.time()
                    cpu_time = time.clock()
                
                    if 'arch' in keys:
                        
                        model.load_weights('weights_temp.hp5')
                
                    else:
                    
                        model.load_weights('weights_default.hp5')
                
                    model.compile(optimizer=parameters['opt'], loss='binary_crossentropy', metrics=[Loss_functions.mean_iou])
                    results = model.fit_generator(parameters['augment'].flow((X_train,X_feat_train),Y_train,batch_size=batch_size), verbose=2,validation_data=([X_val, X_feat_val], Y_val),steps_per_epoch=3600 // batch_size, epochs=100, callbacks=[reduceLR, earlystopper],shuffle=True,workers=1,use_multiprocessing=False,max_queue_size=3)
                
                    cpu_time_list.append(time.clock() - cpu_time)
                    # memory_used.append(psutil.virtual_memory().percent)
                
#                     model.save(filename)
                
                    min_val_loss_index = results.history['val_loss'].index(min(results.history['val_loss']))
        
                    min_val_loss_list.append(results.history['val_loss'][min_val_loss_index])
                    mean_iou_list.append(results.history['val_mean_iou'][min_val_loss_index])
                    
                    final_val_loss_list.append(results.history['val_loss'][-1])
                    final_lr_list.append(results.history['lr'][-1])
                    
                    number_epochs_list.append(len(results.epoch))

                if 'arch' in keys:

                    del model
                    K.clear_session()
                    gc.collect()

                    if 'opt' in keys:

                        k = 'opt'

                        pdf = params_df[k]
                        param = pdf.loc[j,k]

                        # x = pdf.loc[j,pdf.columns.difference([k+'_name',k])].dropna().to_dict()
        
                        parameters[k] = param(**pdf.loc[j,pdf.columns.difference([k + '_name',k])].dropna().to_dict())
                        names_dict[k] = pdf.loc[j,k + '_name']

                    else:

                        self.defaults['opt'] = Trainer.instanciate(self.default_parameters['opt'],'opt')

                line[f'cpu_time'] = cpu_time_list
                line[f'min_val_loss'] = min_val_loss_list
                line[f'mean_iou_of_min_val_loss'] = mean_iou_list
                line[f'final_val_loss'] = final_val_loss_list
                line[f'final_lr'] = final_lr_list
                line[f'number_epochs'] = number_epochs_list

                # if update_best_para:

                #     last_loss = np.mean(min_val_loss_list)

                #     if last_loss < best_loss:

                #         best_loss = last_loss

                #         for k in keys:

                #             new_best_parameters[k] = pdf.loc[j,pdf.columns.difference([k + '_name',k])].dropna().to_dict()
                #             new_best_parameters[k][k] = pdf.loc[j,k]


#                 print(line.memory_usage())
#                 print(df_temp.memory_usage())
                
#                 print(line)
                
                df_temp = df_temp.append(line,ignore_index=True)

                df_temp.to_pickle(directory + f'temp{i}.pkl')
                
#                 print(df_temp)

            # if update_best_para:

            #     self.default_parameters = new_best_parameters
            #     print(new_best_parameters)

            print(self.default_parameters)

            if 'arch' in keys:

                self.defaults['arch'] = Trainer.instanciate(self.default_parameters['arch'],'arch')

            if bypass_first_time:

                bypass_first_time = False

            else:

                df_temp.to_pickle(directory + f'temp{i}.pkl')
                print(f"Done test {i+1}-{j+1} : {name}")
                    
            df_temp_list.append(df_temp)

        # plt.plot(range(len(memory_used)),memory_used)
        plt.savefig('plot.png')
            
        df_record = pd.concat(df_temp_list, keys=[f"step {i+1}" for i in range(n)])
        
        return df_record
    
    def instanciate(d,name):
        
        return d[name](**{l:w for l,w in d.items() if l != name})
                
            
#     def cross_prod(plan):
        
#         keys = [*plan[i]]
        
#         return index
