
import os
import google.protobuf
import sys
import caffe
import numpy as np


path_to_network = '/home/hpc_anna1985/Kaggle/Diabetic-Retinopathy-Detection/Code/traincaffe/networks/minimal/'
path_to_model = '/storage/hpc_anna/Kaggle_DRD/caffeinput/size256/stored_models/'

net_prev = caffe.Net(path_to_network + 'network_minimal.prototxt', path_to_model + 'model_minimal_%i.caffemodel' % 450000, caffe.TRAIN)
net_curr = caffe.Net(path_to_network + 'network_minimal.prototxt', path_to_model + 'model_minimal_%i.caffemodel' % 990000, caffe.TRAIN)

# params_prev = net_prev.params.keys()
# params_curr = net_curr.params.keys()

weights_prev = net_prev.params['fc1'][0].data
weights_curr = net_curr.params['fc1'][0].data

updates = np.abs(weights_curr - weights_prev)
ratio_weight_updates = updates / weights_prev.astype('float64')

print np.mean(ratio_weight_updates)




# source_params = {pr: (net.params[pr][0].data, net.params[pr][1].data) for pr in params}
# print net.params['fc1'][0].data
#for pr in params:
#    print source_params[pr][1]  #bias
#    print '_____________'    
#    print source_params[pr][0]  #weights



