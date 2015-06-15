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
predictions_in_file = '/storage/hpc_anna/Kaggle_DRD/' + prefix + 'caffeinput/' + preprocessing_type + '/' + subset + '.txt'
img_out_dir = '/storage/hpc_anna/Kaggle_DRD/' + prefix + 'features/' + preprocessing_type + '/model_' + model_name + '/reconstructed'

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
prediction_dict = dict()
with open(predictions_in_file, 'r') as f:
	for i, line in enumerate(f):
		
		# display progress
            	sys.stdout.write('{0}/{1}\r'.format(i, num_images))
            	sys.stdout.flush()

		# extract filename
		(filename, cls) = line.split(' ')
		
		# unflatten the image array
		image = data[i].reshape(3, 256, 256)

		# set channel dimension to be the last dimension
		image = image.transpose(1, 2, 0)

		# store the image
		plt.imsave(img_out_dir + '/' + filename, image)


