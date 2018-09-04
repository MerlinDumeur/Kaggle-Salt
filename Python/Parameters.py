IDG_fliplr = [True]

IDG_dict = {'vertical_flip':IDG_fliplr}
default_IDG = {k:v[0] for k,v in IDG_dict.items()}
default_IDG['augment']=ImageDataGenerator