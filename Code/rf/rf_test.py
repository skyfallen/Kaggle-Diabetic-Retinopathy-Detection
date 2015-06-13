from sklearn.ensemble import RandomForestClassifier
import numpy as np
import os
from scipy.misc import imsave,imread
from sklearn.grid_search import GridSearchCV
from datetime import datetime
import cPickle

def load_subset(subset):
        images_labels = {}
        path_to_images = '/storage/hpc_anna/Kaggle_DRD/images/b10size256/' + subset
        labels_file = '/storage/hpc_anna/Kaggle_DRD/caffeinput/b10size256/' + subset + '.txt'
        images_labels = {}
        with open(labels_file, 'r') as f:
                dict_labels = dict([line.strip().split() for line in f.readlines()])
        # List files in this directory
        files = os.listdir(path_to_images)
	files = files[40000:]

        # Create structure for holding images
        images = np.zeros((len(files), 256*256*3), dtype=np.uint8)
        labels = np.zeros(len(files), dtype=np.uint8)
        for fid, file in enumerate(files):
                if fid % 100 == 0:
                        print fid
                image = imread(path_to_images + '/' + file)
                if image.shape == (256, 256, 3):
                        images[fid] = image.flatten()
                        labels[fid] = int(dict_labels[file])
        return images, labels, files


test_images, test_labels, test_files = load_subset('test')

print "Loading model..."
with open('/storage/hpc_anna/Kaggle_DRD/rf/b10size256/rf_500_auto.pkl', 'r') as f:
	CV_rfc = cPickle.load(f)

print "Predictions aer computed..."
test_predictions = CV_rfc.predict(test_images)

print "Saving results..."
date = datetime.now()
date = date.strftime("%Y-%m-%d-%H-%M")
with open('/storage/hpc_anna/Kaggle_DRD/predictions/b10size256/' + date + '_predictions_rf_test.csv', 'w') as f:
        f.write('image,level\n')
        for fid, file in enumerate(test_files):
                f.write(file + ',' + str(test_predictions[fid]) + '\n')
print 'Submission file saved as' + '/storage/hpc_anna/Kaggle_DRD/predictions/b10size256/' + date + '_predictions_rf_test.csv'
