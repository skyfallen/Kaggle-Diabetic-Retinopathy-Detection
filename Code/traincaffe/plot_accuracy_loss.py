#
#  Used as a part of plotaccloss.sh script plot accuracy and loss via matplotlib
#

import os
import sys
import matplotlib.pyplot as plt
from datetime import datetime

if len(sys.argv) < 4:
  print 'Usage:', sys.argv[0], '<prefix> <preprocessing_type> <model_name>'
  sys.exit(2)

prefix=sys.argv[1]
if prefix == 'EMPTY':
	prefix = ''
preprocessing_type = sys.argv[2]
model_name = sys.argv[3]

# get current date and time to use in file names
date = datetime.now()
date = date.strftime('%Y-%m-%d-%H-%M')

# read files with the scores
user = os.environ['USER']
with open('/tmp/' + user + '_plot_train_acc.txt') as f:
    train_acc = [float(x) for x in f.readlines()]
with open('/tmp/' + user + '_plot_test_acc.txt') as f:
    test_acc = [float(x) for x in f.readlines()]
with open('/tmp/' + user + '_plot_train_loss.txt') as f:
    train_loss = [float(x) for x in f.readlines()]
with open('/tmp/' + user + '_plot_test_loss.txt') as f:
    test_loss = [float(x) for x in f.readlines()]

# save plots
plt.plot(train_acc, label='Training accuracy')
plt.plot(test_acc, label='Test accuracy')
plt.legend(loc='lower right')
plt.savefig('/home/' + user + '/Kaggle/Diabetic-Retinopathy-Detection/Code/traincaffe/networks/' + preprocessing_type + '/' + prefix + model_name + '/plots/' + date + '_accuracy.png')
plt.show()

plt.clf()
plt.plot(train_loss, label='Training loss')
plt.plot(test_loss, label='Test loss')
plt.legend(loc='upper right')
plt.savefig('/home/' + user + '/Kaggle/Diabetic-Retinopathy-Detection/Code/traincaffe/networks/' + preprocessing_type + '/' + prefix + model_name + '/plots/' + date + '_loss.png')
plt.show()

