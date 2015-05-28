#!/bin/bash

#
# Calculate squared kappa for the predictions
#
# Usage: ./calculate_kappa.sh PREFIX PREPROC MODELNAME SUBSET
# Example: ./calculate_kappa.sh "" size256 basic test
#

PREFIX=$1
PREPROC=$2
MODELNAME=$3
SUBSET=$4
CONFIRM=$5

if [ "$PREFIX" == "EMPTY" ]; then
	PREFIX=""
fi

if [ "$CONFIRM" != "NOCONFIRM" ]; then
	echo "Running with PREFIX="$PREFIX" PREPROC="$PREPROC" MODELNAME="$MODELNAME" SUBSET="$SUBSET
	read -n1 -r -p "Is it OK? (any key if yes, ^C if no)" key
fi 
sort "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"caffeinput/"$PREPROC"/"$SUBSET".txt" | gawk '{print $2}' > "/tmp/"$USER"_sorted_actual.txt"
sort "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"predictions/"$PREPROC"/predictions_"$MODELNAME"_"$SUBSET".txt" | gawk '{print $2}' > "/tmp/"$USER"_sorted_predicted.txt"
paste -d\  "/tmp/"$USER"_sorted_actual.txt" "/tmp/"$USER"_sorted_predicted.txt" > "/tmp/"$USER"_actual_and_predicted_labels.txt"

source ~/Python/bin/activate
python $HOME/Kaggle/Diabetic-Retinopathy-Detection/Code/traincaffe/kappa.py -s "/tmp/"$USER"_actual_and_predicted_labels.txt"
