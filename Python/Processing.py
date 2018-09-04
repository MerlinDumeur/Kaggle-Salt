from Constants import *

DEPTHS_PATH = '../Kaggle-TGS/depths.csv'
TRAIN_PATH = '../Kaggle-TGS/train.csv'


def generate_dataframes(save=True):

    df = pd.read_csv(DEPTHS_PATH,index_col=0,dtype={'z':'uint16'})
    train_df = pd.read_csv(TRAIN_PATH,index_col=0,keep_default_na=False)

    df['image'] = [read_image(idx) for idx in tqdm_notebook(df.index)]
    train_df['masks'] = [read_image(idx,True) for idx in tqdm_notebook(train_df.index)]

    stratify(train_df)

    if save:

        df.to_pickle('df.pkl.gzip')
        train_df.to_pickle('train_df.pkl.gzip')

    return (df,train_df)


def load_dataframes():

    df = pd.read_pickle('df.pkl.gzip')
    train_df = pd.read_pickle('train_df.pkl.gzip')

    return (df,train_df)


def stratify_by_coverage(train_df):

    train_df['coverage'] = train_df.masks.map(np.sum) / (IMG_WIDTH * IMG_HEIGHT)

    hist, bin_edges = np.histogram(train_df.coverage,bins=10)

    def get_strata(i,bins):
        return next(x[0] for x in enumerate(bins) if x[1] >= i)

    f = lambda i: get_strata(i,bin_edges)

    train_df['strata'] = train_df.coverage.map(f).astype('uint8')

    # fig, axs = plt.subplots(1, 2, figsize=(15,5))
    # sns.distplot(train_df.coverage, kde=False, ax=axs[0])
    # sns.distplot(train_df.strata, bins=10, kde=False, ax=axs[1])
    # plt.suptitle("Salt coverage")
    # axs[0].set_xlabel("Coverage")
    # axs[1].set_xlabel("Coverage class")
    # plt.show()


def read_image(id_,mask=False):

    path = (MASK_PATH if mask else TRAIN_PATH) if id_ in train_df.index.values else TEST_PATH
    
    img = imread(path + id_ + '.png')[:,:,:IMG_CHANNELS] if not mask else imread(path + id_ + '.png')
    img = resize(img, (IMG_HEIGHT, IMG_WIDTH), mode='constant', preserve_range=True)
    
    if mask:
    
        img = np.expand_dims(img, axis=-1)
        img = img.astype('bool',copy=False)
        
    else:
        
        img = img.astype('uint8',copy=False)
    
    return img
