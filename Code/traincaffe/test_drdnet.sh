#!/bin/bash

#
# Extract network activations when run on test data
#

PREFIX='sample_'
PREPROC='size256'
MODELNAME='basic'

# remove previous results
rm -rf "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"features/"$PREPROC"/features_basic"

# extract
srun --mem=8000 \
$HOME"/Software/Caffe/build/tools/extract_features.bin" "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"caffeinput/"$PREPROC"/model_"$MODELNAME"_iter_500.caffemodel" \
"/home/hpc_kuz/Kaggle/Diabetic-Retinopathy-Detection/Code/traincaffe/networks/network_"$MODELNAME"_test.prototxt" \
prob \
"/storage/hpc_anna/Kaggle_DRD/"$PREFIX"features/"$PREPROC"/features_"$MODELNAME 107 lmdb

# change permissions to the extracted features
chmod -R 777 "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"features/"$PREPROC"/features_"$MODELNAME

# extract labels from LMDB
rm "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"predictions/"$PREPROC"/predictions_"$MODELNAME".txt"
source ~/Python/bin/activate
python $HOME/Kaggle/Diabetic-Retinopathy-Detection/Code/traincaffe/lmdb2predictions.py $PREPROC $MODELNAME
chmod 777 "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"predictions/"$PREPROC"/predictions_"$MODELNAME".txt"
