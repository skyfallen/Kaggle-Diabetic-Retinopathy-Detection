#
#  Taking randomly images in order to create sample of a training set 
#
ls  /storage/hpc_anna/Kaggle_DRD/images/raw/train |sort -R |tail -n 71 |while read file; do
	cp  /storage/hpc_anna/Kaggle_DRD/images/raw/train/$file /storage/hpc_anna/Kaggle_DRD/sample_images/raw/train
	#echo "/storage/hpc_anna/Kaggle_DRD/images/raw/train/$file /storage/hpc_anna/Kaggle_DRD/sample_images/raw/train"
done
