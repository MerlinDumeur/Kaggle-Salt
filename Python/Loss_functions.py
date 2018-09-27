import tensorflow as tf
from keras import backend as K
import numpy as np

# conf = tf.ConfigProto(device_count = {'GPU':0})
# conf = tf.ConfigProto(device_count = {'GPU':0})
# conf.gpu_options.per_process_gpu_memory_fraction = 0.1
# conf.gpu_options.visible_device_list = ""
# conf.device_count = {'GPU':0,'CPU':1}
# session = tf.Session(config=conf)
# K.set_session(session)


def mean_iou(y_true, y_pred):

    prec = []

    for t in np.arange(0.5, 1.0, 0.05):
    
        y_pred_ = tf.to_int32(y_pred > t)
        score, up_opt = tf.metrics.mean_iou(y_true, y_pred_, 2)
        K.get_session().run(tf.local_variables_initializer())
    
        with tf.control_dependencies([up_opt]):
            score = tf.identity(score)
    
        prec.append(score)
    
    return K.mean(K.stack(prec), axis=0)
