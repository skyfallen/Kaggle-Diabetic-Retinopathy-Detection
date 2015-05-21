#!/bin/bash

#
# Extract network activations when run on test or validation data
#
# Usage: ./test_drdnet.sh PREFIX PREPROC MODELNAME SUBSET NSAMPLES
# Example: ./test_drdnet.sh "" size256 basic test 107
#

PREFIX=$1
PREPROC=$2
MODELNAME=$3
SUBSET=$4
NSAMPLES=$5

echo "Running with PREFIX="$PREFIX" PREPROC="$PREPROC" MODELNAME="$MODELNAME" SUBSET="$SUBSET" and NSAMPLES="$NSAMPLES
read -n1 -r -p "Is it OK? (any key if yes, ^C if no)" key

# remove previous results
rm -rf "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"features/"$PREPROC"/features_"$MODELNAME"_"$SUBSET

# extract
srun --partition=gpu --gres=gpu:1 --constraint=K20 --mem=10000 \
$HOME"/Software/Caffe/build/tools/extract_features.bin" "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"caffeinput/"$PREPROC"/model_"$MODELNAME"/model_iter_1000000.caffemodel" \
"/home/hpc_anna1985/Kaggle/Diabetic-Retinopathy-Detection/Code/traincaffe/networks/"$MODELNAME"/network_"$MODELNAME"_"$SUBSET".prototxt" \
prob \
"/storage/hpc_anna/Kaggle_DRD/"$PREFIX"features/"$PREPROC"/features_"$MODELNAME"_"$SUBSET $NSAMPLES lmdb GPU 0

# wait until features folder is stored to the hard drive
echo "Sleeping ..."
sleep 60

# change permissions to the extracted features
chmod -R 777 "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"features/"$PREPROC"/features_"$MODELNAME"_"$SUBSET

# extract labels from LMDB
rm "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"predictions/"$PREPROC"/predictions_"$MODELNAME"_"$SUBSET".txt"
source ~/Python/bin/activate
if [ "$PREFIX" == "" ]; then
	python $HOME/Kaggle/Diabetic-Retinopathy-Detection/Code/traincaffe/lmdb2predictions.py EMPTY $PREPROC $MODELNAME $SUBSET
else
	python $HOME/Kaggle/Diabetic-Retinopathy-Detection/Code/traincaffe/lmdb2predictions.py $PREFIX $PREPROC $MODELNAME $SUBSET
fi
chmod 777 "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"predictions/"$PREPROC"/predictions_"$MODELNAME"_"$SUBSET".txt"
