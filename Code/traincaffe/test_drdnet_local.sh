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
NITER=$4
SUBSET=$5
NSAMPLES=$(ls "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"images/"$PREPROC"/"$SUBSET"/" | wc -l)

echo "Running with PREFIX="$PREFIX" PREPROC="$PREPROC" MODELNAME="$MODELNAME" NITER="$NITER" SUBSET="$SUBSET" and NSAMPLES="$NSAMPLES
read -n1 -r -p "Is it OK? (any key if yes, ^C if no)" key

# create output directories
mkdir "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"features/"$PREPROC
mkdir "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"features/"$PREPROC"/model_"$MODELNAME

# remove previous result
rm -rf "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"features/"$PREPROC"/features_"$MODELNAME"_"$SUBSET

# extract
$HOME"/Software/Caffe/build/tools/extract_features.bin" "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"caffeinput/"$PREPROC"/model_"$MODELNAME"/model_iter_"$NITER".caffemodel" \
$HOME"/Kaggle/Diabetic-Retinopathy-Detection/Code/traincaffe/networks/"$PREPROC"/"$MODELNAME"/network_"$MODELNAME"_"$SUBSET".prototxt" \
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

# ask user whether he wants to store this result as a Kaggle submission
if [ "$SUBSET" == "test" ]; then
	echo -n "Would you like to store a submission for Kaggle (type 'yes'): "
	read storesubmission

	# store the model and convert predictions to kaggle model
	if [ "$storesubmission" == "yes" ]; then
		
		# create backup folder
		curdate=$(date +%Y-%m-%d-%H-%M)
		mkdir "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"submissions/"$PREPROC
		mkdir "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"submissions/"$PREPROC"/"$MODELNAME
		storeto="/storage/hpc_anna/Kaggle_DRD/"$PREFIX"submissions/"$PREPROC"/"$MODELNAME"/"$curdate
		mkdir $storeto
		
		# copy model files
		cp "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"caffeinput/"$PREPROC"/model_"$MODELNAME"/model_iter_"$NITER".caffemodel" $storeto
		cp "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"caffeinput/"$PREPROC"/model_"$MODELNAME"/model_iter_"$NITER".solverstate" $storeto

		# convert predictions to Kaggle-acceptable format
		outfile="/storage/hpc_anna/Kaggle_DRD/"$PREFIX"submissions/"$PREPROC"/"$MODELNAME"/"$curdate"/submission_"$PREPROC"_"$MODELNAME".csv"
		echo "image,level" > $outfile
		cat "/storage/hpc_anna/Kaggle_DRD/predictions/"$PREPROC"/predictions_"$MODELNAME"_test.txt" | sed 's/ /,/g' | sed 's/.jpg//g' >> $outfile

		# give rights to submissions folder
		chmod -R 777 $storeto

		# write down what was stored
		nsub=$(cat $HOME"/Kaggle/Diabetic-Retinopathy-Detection/README.md" | wc -l)
		let "nsub -= 1"
		echo "|"$nsub"|"$storeto"|"$kappa"|||" >> $HOME"/Kaggle/Diabetic-Retinopathy-Detection/README.md"
	fi
else
	# calculate Kappa
	echo 'Calculating Kappa ...'
	if [ "$PREFIX" == "" ]; then
        	kappa=`$HOME"/Kaggle/Diabetic-Retinopathy-Detection/Code/traincaffe/calculate_kappa.sh" EMPTY $PREPROC $MODELNAME $SUBSET NOCONFIRM`
	else
        	kappa=`$HOME"/Kaggle/Diabetic-Retinopathy-Detection/Code/traincaffe/calculate_kappa.sh" $PREFIX $PREPROC $MODELNAME $SUBSET NOCONFIRM`
	fi
	echo "k = "$kappa
fi














