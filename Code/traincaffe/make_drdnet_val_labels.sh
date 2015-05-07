#!/bin/bash
cd /storage/hpc_anna/Kaggle_DRD/sample_images/size256/val
ls * | sed 's/^/\^/g' > ../val_files.txt
egrep -f /storage/hpc_anna/Kaggle_DRD/sample_images/size256/val_files.txt /storage/hpc_anna/Kaggle_DRD/input/trainCaffeLables.csv > /storage/hpc_anna/Kaggle_DRD/sample_caffeinput/size256/val.txt
rm /storage/hpc_anna/Kaggle_DRD/sample_images/size256/val_files.txt

