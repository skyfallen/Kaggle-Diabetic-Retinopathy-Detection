#!/usr/bin/env python

import sys
import lmdb
import numpy as np
import caffe

if len(sys.argv) < 3:
  print 'Usage:', sys.argv[0], '<preprocessing_type> <model_name>'
  print 'Usage example: python lmdb2predictions.py size256 basic'
  sys.exit(2)

preprocessing_type = sys.argv[1]
model_name = sys.argv[2]
features_lmdb_path = '/storage/hpc_anna/Kaggle_DRD/sample_features/' + preprocessing_type + '/features_' + model_name
predictions_in_file = '/storage/hpc_anna/Kaggle_DRD/sample_caffeinput/test.txt'
predictions_out_file = '/storage/hpc_anna/Kaggle_DRD/sample_predictions/' + preprocessing_type + '/predictions_' + model_name + '.txt'

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
i = 0
with open(predictions_in_file, 'r') as f:
	for line in f:
		prediction_dict[line.split(' ')[0]] = np.argmax(data[i, :])
	
# store predictions to file
with open(predictions_out_file, 'w') as f:
	for key, value in prediction_dict.iteritems():
		f.write(str(key) + ' ' + str(value) + '\n')


#np.savez_compressed(npz_file, data=data, labels=labels)





