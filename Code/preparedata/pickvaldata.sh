#
# Random sampling of validation images
#

#ls  /storage/hpc_anna/Kaggle_DRD/images/raw/train |sort -R |tail -n 7026 |while read file; do
#	mv  /storage/hpc_anna/Kaggle_DRD/images/raw/train/$file /storage/hpc_anna/Kaggle_DRD/images/raw/val
	#echo "/storage/hpc_anna/Kaggle_DRD/images/raw/train/$file /storage/hpc_anna/Kaggle_DRD/images/raw/val"
#done

# Pick sample for validation from augmented data
 ls  /storage/hpc_anna/Kaggle_DRD/images/augm256/trainval |sort -R |tail -n 112400 |while read file; do
       mv  /storage/hpc_anna/Kaggle_DRD/images/augm256/trainval/$file /storage/hpc_anna/Kaggle_DRD/images/augm256/train
       #echo "/storage/hpc_anna/Kaggle_DRD/images/augm256/trainval/$file /storage/hpc_anna/Kaggle_DRD/images/augm256/val"
done

