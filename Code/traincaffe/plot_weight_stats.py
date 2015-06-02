#!/usr/bin/env python

# extract network statistics from caffe network snapshots 

import os
import google.protobuf
import sys
import caffe
import numpy as np
import re
import matplotlib.pyplot as plt

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

# set path to network and model
path_to_network = '/home/hpc_anna1985/Kaggle/Diabetic-Retinopathy-Detection/Code/traincaffe/networks/'+ preprocessing_type + '/' +  model_name + '/'
path_to_model = '/storage/hpc_anna/Kaggle_DRD/' + prefix + 'caffeinput/' + preprocessing_type + '/model_' + model_name + '/'

# extract snapshots in the network directory
files = os.listdir(path_to_model)
files = filter(lambda x: re.search(r'caffemodel', x), files)
snapshots_names = list()
for file in files:
  snapshots_names.append(int(file.split('_')[2].split('.')[0]))

# load the first model
with suppress_stdout_stderr():
  net_curr = caffe.Net(path_to_network + 'network_' + model_name + '.prototxt', path_to_model + 'model_iter_%i.caffemodel' % snapshots_names[0], caffe.TRAIN)

# extract layer names
layer_names = net_curr.params.keys()

# initialize network statistics with zeros 
net_stats_ratios = np.zeros((len(snapshots_names), len(layer_names)))
net_stats_weight_means = np.zeros((len(snapshots_names), len(layer_names)))
net_stats_weight_stds = np.zeros((len(snapshots_names), len(layer_names)))

for sid,snapshot_name in enumerate(snapshots_names):
  print snapshot_name
  net_prev = net_curr
  with suppress_stdout_stderr():
    net_curr = caffe.Net(path_to_network + 'network_' + model_name + '.prototxt', path_to_model + 'model_iter_%i.caffemodel' % snapshot_name, caffe.TRAIN)

  for lid,layer_name in enumerate(layer_names):
    weights_prev = net_prev.params[layer_name][0].data
    weights_curr = net_curr.params[layer_name][0].data
    updates = np.abs(weights_curr - weights_prev)
    ratio_weight_updates = updates / weights_prev.astype('float64')

    net_stats_ratios[sid, lid] = np.mean(ratio_weight_updates)
    net_stats_weight_means[sid, lid] = np.mean(weights_curr)
    net_stats_weight_stds[sid, lid] = np.std(weights_curr)

net_stats = np.hstack((net_stats_ratios, net_stats_weight_means, net_stats_weight_stds))

user = os.environ['USER']
date = datetime.now()
date = date.strftime('%Y-%m-%d-%H-%M')

line_objects_ratios = plt.plot(net_stats[:, 0:len(layer_names)])
plt.legend(line_objects_ratios, layer_names, loc="upper left")
plt.xlabel('snapshots')
plt.ylabel('ratio of weights')
plt.grid(True)
plt.savefig('/home/' + user + '/Kaggle/Diabetic-Retinopathy-Detection/Code/traincaffe/networks/' + preprocessing_type + '/' + prefix + model_name + '/plots/' + date + '_weight_ratios.png') 
plt.show()
plt.clf()

line_objects_means = plt.plot(net_stats[:, len(layer_names):2*len(layer_names)])
plt.legend(line_objects_means, layer_names, loc="upper left")
plt.xlabel('snapshots')
plt.ylabel('mean of weights')
plt.grid(True)
plt.savefig('/home/' + user + '/Kaggle/Diabetic-Retinopathy-Detection/Code/traincaffe/networks/' + preprocessing_type + '/' + prefix + model_name + '/plots/' + date + '_mean_weights.png') 
plt.show()
plt.clf()

line_objects_stds = plt.plot(net_stats[:, 2*len(layer_names):3*len(layer_names)])
plt.legend(line_objects_stds, layer_names, loc="upper left")
plt.xlabel('snapshots')
plt.ylabel('stds of weights')
plt.grid(True)
plt.savefig('/home/' + user + '/Kaggle/Diabetic-Retinopathy-Detection/Code/traincaffe/networks/' + preprocessing_type + '/' + prefix + model_name + '/plots/' + date + 'stds_weights.png') 
plt.show()
plt.clf()

# source_params = {pr: (net.params[pr][0].data, net.params[pr][1].data) for pr in params}
# print net.params['fc1'][0].data
#for pr in params:
#    print source_params[pr][1]  #bias
#    print '_____________'    
#    print source_params[pr][0]  #weights



