# Run SVM on retina images
from sklearn import svm
import numpy as np
import os
from scipy.misc import imsave,imread
from sklearn.grid_search import GridSearchCV
from datetime import datetime

# Define directory with images we want to use
def load_subset(subset):
	images_labels = {}
	path_to_images = '/storage/hpc_anna/Kaggle_DRD/images/size256/' + subset
	labels_file = '/storage/hpc_anna/Kaggle_DRD/caffeinput/size256/' + subset + '.txt'
	images_labels = {}
	with open(labels_file, 'r') as f:
		dict_labels = dict([line.strip().split() for line in f.readlines()])
		
	# List files in this directory
	files = os.listdir(path_to_images)
	
	# Create structure for holding images
	images = np.zeros((len(files), 256*256*3), dtype=np.uint8)
	labels = []
	for fid, file in enumerate(files):
        	if fid % 1000 == 0:
			print fid
		image = imread(path_to_images + '/' + file)
		images[fid] = image.flatten()
		labels.append(int(dict_labels[file]))

	return images, labels, files

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

#print load_subset('train')
train_images, train_labels, train_files = load_subset('train')
val_images, val_labels, val_files = load_subset('val')
test_images, test_labels, test_files = load_subset('test')
  
param_grid = {'C':[0.00001, 0.0001, 0.001, 0.01, 0.1, 1, 1e2, 1e3, 1e4], 'gamma':[0.0001, 0.01, 0.1, 1],}
#param_grid = {'C':[0.1], 'gamma':[1],}
clf = GridSearchCV(svm.SVC(kernel='rbf', class_weight='auto'), param_grid, verbose=5, n_jobs=12)
clf = clf.fit(train_images, train_labels)
val_predictions = clf.predict(val_images)
print 'Kappa =', kappa(val_labels, val_predictions)

test_predictions = clf.predict(test_images)
date = datetime.now()
date = date.strftime("%Y-%m-%d-%H-%M")
with open('/storage/hpc_anna/Kaggle_DRD/predictions/size256/svm/' + date + '_predictions_svm_test.csv', 'w') as f:
	f.write('image,level\n')
	for fid, file in enumerate(test_files):
		f.write(file + ',' + str(test_predictions[fid]) + '\n')
print 'Submission file saved as' + '/storage/hpc_anna/Kaggle_DRD/predictions/size256/svm/' + date + '_predictions_svm_test.csv' 
