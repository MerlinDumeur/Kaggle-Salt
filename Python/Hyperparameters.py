from itertools import product


class Hyperparameter:
    
    def generate_param_dataframe(class_ref,parameters_dict,name="None",class_type='class'):
        
        if name is None:
            
            name = class_ref.__name__
        
        prod = product(*parameters_dict.values())
        a = np.array([*prod])
        data = {[*parameters_dict][i]:a[:,i] for i in range(len(parameters_dict))}

        df = pd.DataFrame(data=data,columns=[class_type + '_name',class_type,*parameters_dict])
        
        s = '-{}' * len(a[0])
        df[class_type + '_name'] = [name + s.format(*a[i]) for i in range(len(a))]
        df[class_type] = [class_ref for i in range(len(a))]
        
        return df
        
    def generate_final_param_dataframe(input_dict,name_convention,class_type):
        
        df = pd.DataFrame()

        for k in input_dict:

            class_ref = input_dict[k][0]
            parameters_dict = input_dict[k][1]
            name = name_convention[class_ref.__name__]

            df_temp = Hyperparameter.generate_param_dataframe(class_ref,parameters_dict,name=name,class_type=class_type)

            df = pd.concat([df,df_temp],axis=0,sort=False,copy=False,ignore_index=True)

        return df

    def get_df(self):

        return self.df


class Augmentation(Hyperparameter):
    
    def __init__(self,datagen_dict):
        
        augment_dict = {
            'ImageDataGenerator':'IDG'
        }
        
        self.df = Hyperparameter.generate_final_param_dataframe(datagen_dict,name_convention=augment_dict,class_type='augment')


class Arch(Hyperparameter):
    
    def __init__(self,model_dict):
        
        names = {
            'UNET':'UNET'
        }
        
        self.df = Hyperparameter.generate_final_param_dataframe(model_dict,name_convention=names,class_type='arch')


class Optimizers(Hyperparameter):
    
    def __init__(self,opt_dict):
        
        opt_names_dict = {
            'SGD':'SGD',
            'RMSprop':'RMS',
            'Adam':'ADM',
            'Adamax':'ADX',
            'Adagrad':'ADG',
            'Adadelta':'ADD',
            'Nadam':'NAD'
        }
        
        self.df_opt = Hyperparameter.generate_final_param_dataframe(opt_dict,name_convention=opt_names_dict,class_type='opt')
