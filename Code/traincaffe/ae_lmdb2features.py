#!/usr/bin/env python

import sys
import lmdb
import numpy as np
import caffe
import matplotlib.pyplot as plt

if len(sys.argv) != 5:
  print 'Usage:', sys.argv[0], '<prefix> <preprocessing_type> <model_name> <subset>'
  print 'Usage example: python lmdb2predictions.py EMPTY size256 basic test'
  sys.exit(2)

prefix=sys.argv[1]
if prefix == 'EMPTY':
	prefix = ''
preprocessing_type = sys.argv[2]
model_name = sys.argv[3]
subset = sys.argv[4]
features_lmdb_path = '/storage/hpc_anna/Kaggle_DRD/' + prefix + 'features/' + preprocessing_type + '/features_' + model_name + '_' + subset
labels_in_file = '/storage/hpc_anna/Kaggle_DRD/' + prefix + 'caffeinput/' + preprocessing_type + '/' + subset + '.txt'
features_out_dir = '/storage/hpc_anna/Kaggle_DRD/' + prefix + 'features/' + preprocessing_type + '/model_' + model_name + '/bottleneck'

env = lmdb.open(features_lmdb_path)
env_stat = env.stat()
num_images = env_stat['entries']
print "Number of images: ", num_images

print "Extracting data from LMDB..."
data = None
counter = 0
with env.begin() as txn:
    with txn.cursor() as curs:
        for key, value in curs:
	
            # convert value to numpy array
            datum = caffe.proto.caffe_pb2.Datum()
            datum.ParseFromString(value)
            arr = caffe.io.datum_to_array(datum)

            # lazily initialize matrix, once we know number of features
            if data is None:
                num_features = arr.shape[0]
                print "Number of features: ", num_features
                data = np.empty((num_images, num_features))

            # copy data to matrix
	    data[int(key), ] = arr[:, 0, 0]

	    # display progress
            sys.stdout.write('{0}/{1}\r'.format(counter, num_images))
            sys.stdout.flush()
            counter += 1

env.close()
print "Storing reconstructed images..."

labels = np.zeros(num_images)
with open(labels_in_file, 'r') as f:
	for i, line in enumerate(f):
		# extract class labels
		(filename, cls) = line.split(' ')
		labels[i] = int(cls)

# save both features and labels
np.save(features_out_dir + '/' + subset + 'labels.npy', labels)
np.save(features_out_dir + '/' + subset + 'features.npy', data)


