#
# Taking randomly images in order to create sample of a validation set
#
ls  /storage/hpc_anna/Kaggle_DRD/images/raw/val |sort -R |tail -n 20 |while read file; do
	cp  /storage/hpc_anna/Kaggle_DRD/images/raw/val/$file /storage/hpc_anna/Kaggle_DRD/sample_images/raw/val
	#echo "/storage/hpc_anna/Kaggle_DRD/images/raw/val/$file /storage/hpc_anna/Kaggle_DRD/sample_images/raw/val"
done
