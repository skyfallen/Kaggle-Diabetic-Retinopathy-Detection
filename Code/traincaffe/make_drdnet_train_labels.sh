#
# Creates file with image names and labels for train
#

#!/bin/bash
cd /storage/hpc_anna/Kaggle_DRD/sample_images/size256/train
ls * | sed 's/^/\^/g' > ../train_files.txt
egrep -f /storage/hpc_anna/Kaggle_DRD/sample_images/size256/train_files.txt /storage/hpc_anna/Kaggle_DRD/images/trainCaffeLables.csv > /storage/hpc_anna/Kaggle_DRD/sample_caffeinput/size256/train.txt
rm /storage/hpc_anna/Kaggle_DRD/sample_images/size256/train_files.txt
