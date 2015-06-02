#!/usr/bin/env python

# extract network statistics from caffe network snapshots 

import os
import google.protobuf
import sys
import caffe
import numpy as np
import re

np.set_printoptions(linewidth=180)

# wrapper class to suppress function output
class suppress_stdout_stderr(object):
    def __init__(self):
        self.null_fds =  [os.open(os.devnull,os.O_RDWR) for x in range(2)]
        self.save_fds = (os.dup(1), os.dup(2))

    def __enter__(self):
        os.dup2(self.null_fds[0],1)
        os.dup2(self.null_fds[1],2)

    def __exit__(self, *_):
        os.dup2(self.save_fds[0],1)
        os.dup2(self.save_fds[1],2)
        os.close(self.null_fds[0])
        os.close(self.null_fds[1])

# check number of command line arguments
if len(sys.argv) < 3:
  print 'Usage:', sys.argv[0], '<prefix> <preprocessing_type> <model_name>'
  print 'Usage example: python explorenetwork.py EMPTY size256 onehidden'
  sys.exit(2)

# replace EMPTY prefix place holder with empty string
prefix=sys.argv[1]
if prefix == 'EMPTY':
  prefix = ''
preprocessing_type = sys.argv[2]
model_name = sys.argv[3]

# set path to netowrk and model
path_to_network = '/home/hpc_anna1985/Kaggle/Diabetic-Retinopathy-Detection/Code/traincaffe/networks/'+ model_name + '/'
path_to_model = '/storage/hpc_anna/Kaggle_DRD/' + prefix + 'caffeinput/' + preprocessing_type + '/model_' + model_name + '/'

# extract snapshots in the network directory
files = os.listdir(path_to_model)
files = filter(lambda x: re.search(r'caffemodel', x), files)
snapshots = list()
for file in files:
  snapshots.append(int(file.split('_')[2].split('.')[0]))

# load the first model
with suppress_stdout_stderr():
  net_curr = caffe.Net(path_to_network + 'network_' + model_name + '.prototxt', path_to_model + 'model_iter_%i.caffemodel' % snapshots[0], caffe.TRAIN)

# extract layer names
layer_names = net_curr.params.keys()

# initialize network statistics with zeros 
net_stats_ratios = np.zeros((len(snapshots), len(layer_names)))
net_stats_weight_means = np.zeros((len(snapshots), len(layer_names)))
net_stats_weight_stds = np.zeros((len(snapshots), len(layer_names)))

for sid,snapshot in enumerate(snapshots):
  net_prev = net_curr
  with suppress_stdout_stderr():
    net_curr = caffe.Net(path_to_network + 'network_' + model_name + '.prototxt', path_to_model + 'model_iter_%i.caffemodel' % snapshot, caffe.TRAIN)

  for lid,layer_name in enumerate(layer_names):
    weights_prev = net_prev.params[layer_name][0].data
    weights_curr = net_curr.params[layer_name][0].data
    updates = np.abs(weights_curr - weights_prev)
    ratio_weight_updates = updates / weights_prev.astype('float64')

    net_stats_ratios[sid, lid] = np.mean(ratio_weight_updates)
    net_stats_weight_means[sid, lid] = np.mean(weights_curr)
    net_stats_weight_stds[sid, lid] = np.std(weights_curr)

net_stats = np.hstack((net_stats_ratios, net_stats_weight_means, net_stats_weight_stds))
print net_stats


# source_params = {pr: (net.params[pr][0].data, net.params[pr][1].data) for pr in params}
# print net.params['fc1'][0].data
#for pr in params:
#    print source_params[pr][1]  #bias
#    print '_____________'    
#    print source_params[pr][0]  #weights



