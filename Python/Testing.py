from keras.callbacks import EarlyStopping, ReduceLROnPlateau
from itertools import product
import psutil
import time
import Loss_functions


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
        
    def execute(self,plan,dataset,batch_size=16,directory="gridsearch/",n_splits=5):

        n = len(plan)
        
        reduceLR = ReduceLROnPlateau(patience=5, verbose=0, factor=0.1)
        earlystopper = EarlyStopping(patience=10, verbose=0, min_delta=0.005)
        
        # index = pd.MultiIndex(levels=[[],[]],
        #                       labels=[[],[]],
        #                       names=[u'plans', u'id'])
        
        df_temp_list = []
        
        for i in range(n):
            
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
            
            for j in range(len(index[0])):
                
                # index_dict = {keys[i]:index[i][j] for i in range(len(keys))}
                
                # parameters = copy.deepcopy(self.defaults)
                parameters = {k:v for k,v in self.defaults.items() if k in defaults}
        
                # names_dict = copy.deepcopy(self.defaults_names)
                names_dict = {k:v for k,v in self.defaults_names.items() if k in defaults}
                
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
                        print(psutil.virtual_memorytual_memory().percent)
                    
                    parameters['augment'].fit(X_train)
                    gen_flow = parameters['augment'].flow((X_train,X_feat_train),Y_train,batch_size=batch_size)
                
#                   checkpointer = ModelCheckpoint(filename, verbose=0, save_best_only=True)
                
                    # clock_time = time.time()
                    cpu_time = time.clock()
                
                    if 'arch' in keys:
                        
                        model.load_weights('weights_temp.hp5')
                
                    else:
                    
                        model.load_weights('weights_default.hp5')
                
                    model.compile(optimizer=parameters['opt'], loss='binary_crossentropy', metrics=[Loss_functions.mean_iou])
                    results = model.fit_generator(gen_flow, verbose=0,validation_data=([X_val, X_feat_val], Y_val),steps_per_epoch=3600 // batch_size, epochs=100, callbacks=[reduceLR, earlystopper],shuffle=True,workers=1,use_multiprocessing=False,max_queue_size=2)
                
                    cpu_time_list.append(time.clock() - cpu_time)
                    
                
#                     model.save(filename)
                
                    min_val_loss_index = results.history['val_loss'].index(min(results.history['val_loss']))
        
                    min_val_loss_list.append(results.history['val_loss'][min_val_loss_index])
                    mean_iou_list.append(results.history['val_mean_iou'][min_val_loss_index])
                    
                    final_val_loss_list.append(results.history['val_loss'][-1])
                    final_lr_list.append(results.history['lr'][-1])
                    
                    number_epochs_list.append(len(results.epoch))
                
                line[f'cpu_time'] = cpu_time_list
                line[f'min_val_loss'] = min_val_loss_list
                line[f'mean_iou_of_min_val_loss'] = mean_iou_list
                line[f'final_val_loss'] = final_val_loss_list
                line[f'final_lr'] = final_lr_list
                line[f'number_epochs'] = number_epochs_list

#                 print(line.memory_usage())
#                 print(df_temp.memory_usage())
                
#                 print(line)
                
                df_temp = df_temp.append(line,ignore_index=True)
                
#                 print(df_temp)
                
            df_temp.to_pickle(directory + f'temp{i}.pkl')
            print(f"Done test {i+1}-{j+1} : {name}")
                
            df_temp_list.append(df_temp)
            
        df_record = pd.concat(df_temp_list, keys=[f"step {i+1}" for i in range(n)])
        
        return df_record
    
    def instanciate(d,name):
        
        return d[name](**{l:w for l,w in d.items() if l != name})
                
            
#     def cross_prod(plan):
        
#         keys = [*plan[i]]
        
#         return index
