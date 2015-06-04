#!/usr/bin/env python

# extract network statistics from caffe network snapshots 

import os
import google.protobuf
import sys
import caffe
import numpy as np
import re
import matplotlib.pyplot as plt
from datetime import datetime

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

#wrapper for weight visualizations
# our network takes BGR images, so we need to switch color channels
def showimage(im, path):
    if im.ndim == 3:
        im = im[:, :, ::-1]
    plt.imsave(path, im)
    
# take an array of shape (n, height, width) or (n, height, width, channels)
#  and visualize each (height, width) thing in a grid of size approx. sqrt(n) by sqrt(n)
def vis_square(data, path, padsize=1, padval=0):
    data -= data.min()
    data /= data.max()
    
    # force the number of filters to be square
    n = int(np.ceil(np.sqrt(data.shape[0])))
    padding = ((0, n ** 2 - data.shape[0]), (0, padsize), (0, padsize)) + ((0, 0),) * (data.ndim - 3)
    data = np.pad(data, padding, mode='constant', constant_values=(padval, padval))
    
    # tile the filters into an image
    data = data.reshape((n, n) + data.shape[1:]).transpose((0, 2, 1, 3) + tuple(range(4, data.ndim + 1)))
    data = data.reshape((n * data.shape[1], n * data.shape[3]) + data.shape[4:])
    
    showimage(data, path)

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
snapshots_names.sort()

   
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
    updates = np.abs(weights_curr - weights_prev) / float(1000)
    ratio_weight_updates = updates / weights_prev.astype('float64')

    net_stats_ratios[sid, lid] = np.mean(ratio_weight_updates)
    net_stats_weight_means[sid, lid] = np.mean(weights_curr)
    net_stats_weight_stds[sid, lid] = np.std(weights_curr)

net_stats = np.hstack((net_stats_ratios, net_stats_weight_means, net_stats_weight_stds))

# prepare env variables need for directory names etc
user = os.environ['USER']
date = datetime.now()
date = date.strftime('%Y-%m-%d-%H-%M')

# visualize weight from each convolutional layer
path_to_plot = '/home/' + user + '/Kaggle/Diabetic-Retinopathy-Detection/Code/traincaffe/networks/' + preprocessing_type + '/' + prefix + model_name + '/plots/' + date + '_feature_squares.png'
vis_square(net_curr.params['conv1'][0].data.transpose(0, 2, 3, 1), path_to_plot)

conv_layer_counter = 0
for layer in net_curr.layers:
    if layer.type == 'Convolution':
	conv_layer_counter += 1
        path_to_plot = '/home/' + user + '/Kaggle/Diabetic-Retinopathy-Detection/Code/traincaffe/networks/' + \
                       preprocessing_type + '/' + prefix + model_name + '/plots/' + date + '_viz_conv' + str(conv_layer_counter) + '.png'
	vis_square(layer.blobs[0].data.transpose(0, 2, 3, 1), path_to_plot)

#net_curr.layers[2].blobs[0].data
#net_curr.layers[5].type

# function to plot stats from all layers on one figure
def plotstats(data, layer_names, ylabel, preprocessing_type, prefix, model_name, filename):
    plt.clf()
    line_objects = plt.plot(data)
    plt.xlabel('snapshots')
    plt.ylabel(ylabel)
    plt.grid(True)
    ax = plt.subplot(111)
    box = ax.get_position()
    ax.set_position([box.x0, box.y0, box.width*0.8, box.height])
    plt.legend(line_objects, layer_names, loc='center left', bbox_to_anchor=(1, 0.5))
    plt.savefig('/home/' + user + '/Kaggle/Diabetic-Retinopathy-Detection/Code/traincaffe/networks/' + preprocessing_type + '/' + prefix + model_name + '/plots/' + filename)
    plt.show()

# plot weights ratio
plotstats(net_stats[:, 0:len(layer_names)], layer_names, 'ratio of weights', preprocessing_type, prefix, model_name, date + '_weight_ratios.png')

# plot mean of weights
plotstats(net_stats[:, len(layer_names):2*len(layer_names)], layer_names, 'mean of weights', preprocessing_type, prefix, model_name, date + '_mean_weights.png')

# standard deviation of weights
plotstats(net_stats[:, 2*len(layer_names):3*len(layer_names)], layer_names, 'stds of weights', preprocessing_type, prefix, model_name, date + '_stds_weights.png')

# source_params = {pr: (net.params[pr][0].data, net.params[pr][1].data) for pr in params}
# print net.params['fc1'][0].data
#for pr in params:
#    print source_params[pr][1]  #bias
#    print '_____________'    
#    print source_params[pr][0]  #weights

