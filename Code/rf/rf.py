# Run Random Forest  on retina images
from sklearn.ensemble import RandomForestClassifier
from sklearn.cross_validation import ShuffleSplit
import numpy as np
import os
from scipy.misc import imsave,imread
from sklearn.grid_search import GridSearchCV
from datetime import datetime
import cPickle

# Define directory with images we want to use
def load_subset(subset):
	images_labels = {}
	path_to_images = '/storage/hpc_anna/Kaggle_DRD/images/b10size256/' + subset
	labels_file = '/storage/hpc_anna/Kaggle_DRD/caffeinput/b10size256/' + subset + '.txt'
	images_labels = {}
	with open(labels_file, 'r') as f:
		dict_labels = dict([line.strip().split() for line in f.readlines()])
	# List files in this directory
	files = os.listdir(path_to_images)
	
	# Create structure for holding images
	images = np.zeros((len(files), 256*256*3), dtype=np.uint8)
	labels = np.zeros(len(files), dtype=np.uint8)
	for fid, file in enumerate(files):
        	if fid % 1000 == 0:
			print fid
		image = imread(path_to_images + '/' + file)
		if image.shape == (256, 256, 3):
			images[fid] = image.flatten()
			labels[fid] = int(dict_labels[file])
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

train_images, train_labels, train_files = load_subset('train')
val_images, val_labels, val_files = load_subset('val')
test_images, test_labels, test_files = load_subset('test')
  
rfc = RandomForestClassifier(n_jobs=-1,max_features= 'sqrt' ,n_estimators=50, oob_score = True) 
param_grid = {
    'n_estimators': [500],
    'max_features': ['auto']
}
CV_rfc = GridSearchCV(estimator=rfc, param_grid=param_grid, cv=ShuffleSplit(test_size=0.20, n_iter=1, random_state=0, n=len(train_images)))
CV_rfc = CV_rfc.fit(train_images, train_labels)
val_predictions = CV_rfc.predict(val_images)
print 'Kappa =', kappa(val_labels, val_predictions)

with open('/storage/hpc_anna/Kaggle_DRD/rf/b10size256/rf_500_auto.pkl', 'w') as f:
	pickle.dump(CV_rfc, f)
 
test_predictions = CV_rfc.predict(test_images)
date = datetime.now()
date = date.strftime("%Y-%m-%d-%H-%M")
with open('/storage/hpc_anna/Kaggle_DRD/predictions/size256/rf/' + date + '_predictions_rf_test.csv', 'w') as f:
	f.write('image,level\n')
	for fid, file in enumerate(test_files):
		f.write(file + ',' + str(test_predictions[fid]) + '\n')
print 'Submission file saved as' + '/storage/hpc_anna/Kaggle_DRD/predictions/size256/rf/' + date + '_predictions_rf_test.csv' 
