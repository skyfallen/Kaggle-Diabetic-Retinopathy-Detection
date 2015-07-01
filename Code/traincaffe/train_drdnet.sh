#!/bin/bash

#
# Train caffe network
#
# Usage: ./train_drdnet.sh PREFIX PREPROC MODELNAME SUBSET NSAMPLES
# Example: ./train_drdnet.sh "" size256 minimal
#

PREFIX=$1
PREPROC=$2
MODELNAME=$3

echo "Running with PREFIX="$PREFIX" PREPROC="$PREPROC" MODELNAME="$MODELNAME
read -n1 -r -p "Is it OK? (any key if yes, ^C if no)" key

#source ~/.bash_profile

if [ -f "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"caffeinput/"$PREPROC"/model_"$MODELNAME"/log.txt" ]; then
    echo "File log.txt already exists in the provided directory! Please, delete log.txt and corresponding caffemodel files prior to training new model."
    exit
fi

mkdir "/storage/hpc_anna/Kaggle_DRD/caffeinput/"$PREPROC"/model_"$MODELNAME
chmod -R 777 "/storage/hpc_anna/Kaggle_DRD/caffeinput/"$PREPROC"/model_"$MODELNAME

if [ "$PREFIX" == "" ]; then
	$HOME"/Kaggle/Diabetic-Retinopathy-Detection/Code/traincaffe/train_drdnet_subroutine.sh" EMPTY $PREPROC $MODELNAME 2> "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"caffeinput/"$PREPROC"/model_"$MODELNAME"/log.txt"
else
	$HOME"/Kaggle/Diabetic-Retinopathy-Detection/Code/traincaffe/train_drdnet_subroutine.sh" $PREFIX $PREPROC $MODELNAME 2> "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"caffeinput/"$PREPROC"/model_"$MODELNAME"/log.txt"
fi

