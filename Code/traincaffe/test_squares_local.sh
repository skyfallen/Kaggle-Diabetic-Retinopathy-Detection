#!/bin/bash

#
# Extract network activations when run on test or validation data
#
# Usage: ./test_squares.sh PREFIX PREPROC MODELNAME SUBSET NSAMPLES
# Example: ./test_squares.sh "" size256 basic test 107
#

PREFIX=$1
PREPROC=$2
MODELNAME=$3
NITER=$4
SUBSET=$5
NSAMPLES=$6

echo "Running with PREFIX="$PREFIX" PREPROC="$PREPROC" MODELNAME="$MODELNAME" NITER="$NITER" SUBSET="$SUBSET" and NSAMPLES="$NSAMPLES
read -n1 -r -p "Is it OK? (any key if yes, ^C if no)" key

# remove previous results
rm -rf "/storage/hpc_kuz/squares/"$PREFIX"features/"$PREPROC"/features_"$MODELNAME"_"$SUBSET

# extract
$HOME"/Software/Caffe/build/tools/extract_features.bin" "/storage/hpc_kuz/squares/"$PREFIX"caffeinput/"$PREPROC"/model_"$MODELNAME"/model_iter_"$NITER".caffemodel" \
$HOME"/Kaggle/Diabetic-Retinopathy-Detection/Code/traincaffe/networks/"$MODELNAME"/network_"$MODELNAME"_"$SUBSET".prototxt" \
prob \
"/storage/"$USER"/squares/"$PREFIX"features/"$PREPROC"/features_"$MODELNAME"_"$SUBSET $NSAMPLES lmdb GPU 0

# change permissions to the extracted features
chmod -R 777 "/storage/hpc_kuz/squares/"$PREFIX"features/"$PREPROC"/features_"$MODELNAME"_"$SUBSET

# extract labels from LMDB
rm "/storage/hpc_kuz/squares/"$PREFIX"predictions/"$PREPROC"/predictions_"$MODELNAME"_"$SUBSET".txt"
python $HOME/Kaggle/Diabetic-Retinopathy-Detection/Code/traincaffe/lmdb2predictions_squares.py $PREPROC $MODELNAME $SUBSET
chmod 777 "/storage/hpc_kuz/squares/"$PREFIX"predictions/"$PREPROC"/predictions_"$MODELNAME"_"$SUBSET".txt"
