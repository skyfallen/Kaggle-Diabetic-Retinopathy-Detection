#!/bin/bash
cd /storage/hpc_anna/Kaggle_DRD/sample_input/size256/train
ls * | sed 's/^/\^/g' > ../train_files.txt
egrep -f /storage/hpc_anna/Kaggle_DRD/sample_input/size256/train_files.txt /storage/hpc_anna/Kaggle_DRD/input/trainCaffeLables.csv > /storage/hpc_anna/Kaggle_DRD/sample_input/size256/train.txt
rm /storage/hpc_anna/Kaggle_DRD/sample_input/size256/train_files.txt
