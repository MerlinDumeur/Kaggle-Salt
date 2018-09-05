from sklearn.model_selection import train_test_split, StratifiedShuffleSplit
import numpy as np


class Dataset:
    
    def __init__(self,df,train_df):
        
        self.df = df
        self.train_df = train_df
        
        learn_ids = self.train_df.index
        test_ids = self.df.index.difference(learn_ids)
        
        self.X_test = np.array(self.df.loc[test_ids,'image'].values.tolist(),dtype='uint8')
        self.X_feat_test = np.array(self.df.loc[test_ids,"z"].values.tolist(),dtype='uint8')
        
    def train_val_test_split(self,test_size,seed=None):
        
        learn_ids = self.train_df.index
        train_ids, val_ids = train_test_split(learn_ids,test_size=test_size,stratify=self.train_df.strata,random_state=seed)
        # test_ids = self.df.index.difference(learn_ids)
        
        self.X_train = np.array(self.df.loc[train_ids,'image'].values.tolist(),dtype='uint8')
        self.Y_train = np.array(self.train_df.loc[train_ids,'masks'].values.tolist(),dtype='bool')
        self.X_feat_train = np.array(self.df.loc[train_ids,"z"].values.tolist(),dtype='uint8')
        
        self.X_val = np.array(self.df.loc[val_ids,'image'].values.tolist(),dtype='uint8')
        self.Y_val = np.array(self.train_df.loc[val_ids,'masks'].values.tolist(),dtype='bool')
        self.X_feat_val = np.array(self.df.loc[val_ids,'z'].values.tolist(),dtype='uint8')
        
    def get_dataframes(self):
        
        return (self.X_train,self.X_feat_train,self.Y_train,self.X_val,self.X_feat_val,self.Y_val,self.X_test,self.X_feat_test)
    
    def sss(self,n_splits,test_size,seed=None):
        
        SSS = StratifiedShuffleSplit(n_splits=n_splits,test_size=test_size,random_state=seed)
        
        for train_ids,val_ids in SSS.split(self.train_df['masks'],self.train_df['strata']):
           
            train_ids = self.train_df.index[train_ids]
            val_ids = self.train_df.index[val_ids]
        
            self.X_train = np.array(self.df.loc[train_ids,'image'].values.tolist(),dtype='uint8')
            self.Y_train = np.array(self.train_df.loc[train_ids,'masks'].values.tolist(),dtype='bool')
            self.X_feat_train = np.array(self.df.loc[train_ids,"z"].values.tolist(),dtype='uint8')
        
            self.X_val = np.array(self.df.loc[val_ids,'image'].values.tolist(),dtype='uint8')
            self.Y_val = np.array(self.train_df.loc[val_ids,'masks'].values.tolist(),dtype='bool')
            self.X_feat_val = np.array(self.df.loc[val_ids,'z'].values.tolist(),dtype='uint8')
        
            yield (self.X_train,self.X_feat_train,self.Y_train,self.X_val,self.X_feat_val,self.Y_val,self.X_test,self.X_feat_test)
