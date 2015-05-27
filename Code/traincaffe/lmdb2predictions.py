#!/usr/bin/env python

import sys
import lmdb
import numpy as np
import caffe

if len(sys.argv) < 4:
  print 'Usage:', sys.argv[0], '<prefix> <preprocessing_type> <model_name> <subset>'
  print 'Usage example: python EMPTY lmdb2predictions.py size256 basic test'
  sys.exit(2)

prefix=sys.argv[1]
if prefix == 'EMPTY':
	prefix = ''
preprocessing_type = sys.argv[2]
model_name = sys.argv[3]
subset = sys.argv[4]
features_lmdb_path = '/storage/hpc_anna/Kaggle_DRD/' + prefix + 'features/' + preprocessing_type + '/features_' + model_name + '_' + subset
predictions_in_file = '/storage/hpc_anna/Kaggle_DRD/' + prefix + 'caffeinput/' + preprocessing_type + '/' + subset + '.txt'
predictions_out_file = '/storage/hpc_anna/Kaggle_DRD/' + prefix +  'predictions/' + preprocessing_type + '/predictions_' + model_name + '_' + subset + '.txt'

env = lmdb.open(features_lmdb_path)
env_stat = env.stat()
num_images = env_stat['entries']
print "Number of images: ", num_images

data = None
with env.begin() as txn:
    with txn.cursor() as curs:
        for key, value in curs:

            # print key

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

env.close()

# read test.txt
prediction_dict = dict()
with open(predictions_in_file, 'r') as f:
	for i, line in enumerate(f):
		prediction_dict[line.split(' ')[0]] = np.argmax(data[i, :])
	
# store predictions to file
with open(predictions_out_file, 'w') as f:
	for key, value in prediction_dict.iteritems():
		f.write(str(key) + ' ' + str(value) + '\n')







