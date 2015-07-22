# Make a balanced train set

import os
import numpy as np
import re
import shutil

# Path to train.txt
path_to_labels = "/storage/hpc_anna/Kaggle_DRD/caffeinput/b400size256/"

# Read in train.txt
old_train = {0:[], 1:[], 2:[],3:[], 4:[]}

bad_images = np.array(["43457_left.jpg", "34689_left.jpg", "32253_right.jpg", "18972_left.jpg", "1986_left.jpg", "679_right.jpg", "21345_left.jpg", "766_left.jpg", "492_right.jpg", "492_left.jpg"])

def is_bad(filename):
	for image in bad_images:
                if re.search('(^|_)' + image, filename):
			return True
	return False

with open(path_to_labels + "train.txt") as f:
    for line in f:
	(filename,clss) = line.split()
	if not is_bad(filename):
		old_train[int(clss)].append(filename)

new_train = {0:[], 1:[], 2:[],3:[], 4:[]}
new_train[0] = old_train[0]
new_train[1] = np.random.choice(old_train[1], len(new_train[0]), replace = True)
new_train[2] = np.random.choice(old_train[2], len(new_train[0]), replace = True)
new_train[3] = np.random.choice(old_train[3], len(new_train[0]), replace = True)
new_train[4] = np.random.choice(old_train[4], len(new_train[0]), replace = True)

source = "/storage/hpc_anna/Kaggle_DRD/images/augm256/train/"
destination = "/storage/hpc_anna/Kaggle_DRD/images/b400size256/train/"

count = 0
for clss,filenames in new_train.iteritems():
	for filename in filenames:
		if count % 100 == 0:
			print count
		if os.path.exists(str(destination + str(filename))):
                        while os.path.exists(str(destination + str(filename))):
                                filename = filename + '1'
			with open(path_to_labels + "train.txt", 'a') as f:
				f.write(filename + ' ' + str(clss))
			f.close()
		shutil.copyfile((source + str(filename)),(destination + str(filename)))
		count=count + 1
