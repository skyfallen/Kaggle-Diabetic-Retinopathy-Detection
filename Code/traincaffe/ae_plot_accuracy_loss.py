#
#  Used as a part of plotaccloss.sh script plot accuracy and loss via matplotlib
#

import os
import sys
import matplotlib.pyplot as plt
from datetime import datetime

if len(sys.argv) != 5:
  print 'Usage:', sys.argv[0], '<prefix> <preprocessing_type> <model_name> <imgdate>'
  sys.exit(2)

prefix=sys.argv[1]
if prefix == 'EMPTY':
	prefix = ''
preprocessing_type = sys.argv[2]
model_name = sys.argv[3]
date = sys.argv[4]

# read files with the scores
user = os.environ['USER']
with open('/tmp/' + user + '_plot_train_crossent.txt') as f:
    train_acc = [float(x) for x in f.readlines()]
with open('/tmp/' + user + '_plot_test_crossent.txt') as f:
    test_acc = [float(x) for x in f.readlines()]
with open('/tmp/' + user + '_plot_train_l2error.txt') as f:
    train_loss = [float(x) for x in f.readlines()]
with open('/tmp/' + user + '_plot_test_l2error.txt') as f:
    test_loss = [float(x) for x in f.readlines()]

# save plots
plt.plot(train_acc, label='Training cross-entropy')
plt.plot(test_acc, label='Test cross-entropy')
plt.legend(loc='lower right')
plt.savefig('/home/' + user + '/Kaggle/Diabetic-Retinopathy-Detection/Code/traincaffe/networks/' + preprocessing_type + '/' + prefix + model_name + '/plots/' + date + '/accuracy.png')
plt.show()

plt.clf()
plt.plot(train_loss, label='Training l2error')
plt.plot(test_loss, label='Test l2error')
plt.legend(loc='upper right')
plt.savefig('/home/' + user + '/Kaggle/Diabetic-Retinopathy-Detection/Code/traincaffe/networks/' + preprocessing_type + '/' + prefix + model_name + '/plots/' + date + '/loss.png')
plt.show()

