# Run SVM on retina images
from sklearn import svm
import numpy as np
import os
import sys
from sklearn.grid_search import GridSearchCV
from datetime import datetime
import cPickle
from sklearn.cross_validation import ShuffleSplit

# Define directory with images we want to use
def load_subset(prefix, preprocessing_type, model_name, subset):
	labels = '/storage/hpc_anna/Kaggle_DRD/' + prefix + 'features/' + preprocessing_type + '/model_' + model_name + '/bottleneck/' + subset + 'labels.npy'
	features  = '/storage/hpc_anna/Kaggle_DRD/' + prefix + 'features/' + preprocessing_type + '/model_' + model_name + '/bottleneck/' + subset + 'features.npy'

	#images_labels = {}
	#with open(labels_file, 'r') as f:
	#	dict_labels = dict([line.strip().split() for line in f.readlines()])
	# List files in this directory
	#files = os.listdir(path_to_images)
	#files = files[0:10000]

	# Create structure for holding images
	#images = np.zeros((len(files), 256*256*3), dtype=np.uint8)
	#labels = np.zeros(len(files), dtype=np.uint8)
	#for fid, file in enumerate(files):
        #	if fid % 1000 == 0:
	#		print fid
	#	image = imread(path_to_images + '/' + file)
	#	if image.shape == (256, 256, 3):
	#		images[fid] = image.flatten()
	#		labels[fid] = int(dict_labels[file])
	labels = np.load(labels)
	data = np.load(features)
	return data, labels

def kappa(labels, predictions):
	labels = np.asarray(labels)
	predictions = np.asarray(predictions)
        
	ratings = np.matrix((labels, predictions)).T

        categories = int(np.amax(ratings)) + 1
        subjects = ratings.size / 2

        # Build weight matrix
        weighted = np.empty((categories, categories))
        for i in range(categories):
                for j in range(categories):
                        weighted[i, j] = abs(i - j) ** 2

        # Build observed matrix
        observed = np.zeros((categories, categories))
        distributions = np.zeros((categories, 2))
        for k in range(subjects):
                observed[ratings[k, 0], ratings[k, 1]] += 1
                distributions[ratings[k, 0], 0] += 1
                distributions[ratings[k, 1], 1] += 1

        # Normalize observed and distribution arrays
        observed = observed / subjects
        distributions = distributions / subjects

        # Build expected array
        expected = np.empty((categories, categories))
        for i in range(categories):
                for j in range(categories):
                        expected[i, j] = distributions[i, 0] * distributions[j, 1]

        # Calculate kappa
        kappa = 1.0 - (sum(sum(weighted * observed)) / sum(sum(weighted * expected)))
	return kappa


if len(sys.argv) != 4:
  print 'Usage:', sys.argv[0], '<prefix> <preprocessing_type> <model_name>'
  print 'Usage example: python ae_svm.py EMPTY size256 basic'
  sys.exit(2)

prefix=sys.argv[1]
if prefix == 'EMPTY':
        prefix = ''
preprocessing_type = sys.argv[2]
model_name = sys.argv[3]

print 'extracting training data...'
train_data, train_labels = load_subset(prefix, preprocessing_type, model_name, 'train')
print 'extracting val data...'
val_data, val_labels = load_subset(prefix, preprocessing_type, model_name,'val')
  
#param_grid = {'C':[0.00001, 0.0001, 0.001, 0.01, 0.1, 1, 1e2, 1e3, 1e4], 'gamma':[0.0001, 0.01, 0.1, 1],}
print 'Training model...'
param_grid = {'C':[1], 'gamma':[0.0001],}
#clf = GridSearchCV(svm.SVC(kernel='rbf', class_weight='auto'), param_grid, n_jobs=1, cv=ShuffleSplit(test_size=0.20, n_iter=1, random_state=0, n=len(train_images)))
clf = svm.SVC(C = 1, gamma = 0.0001, kernel='rbf', class_weight='auto')
print 'Fitting model...'
clf = clf.fit(train_data, train_labels)
print 'Predicting validation data...'
val_predictions = clf.predict(val_data)
print 'Kappa =', kappa(val_labels, val_predictions)

with open('/storage/hpc_anna/Kaggle_DRD/caffeinput/ae_size256/model_shallow/svm_c1_g0001.pkl', 'w') as f:
        cPickle.dump(clf, f)
print 'Model saved as ' + '/storage/hpc_anna/Kaggle_DRD/caffeinput/ae_size256/model_shallow/svm_c1_g0001.pkl'

