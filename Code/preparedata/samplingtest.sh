#
# Taking randomly images in order to create sample of a test set
#

ls  /storage/hpc_anna/Kaggle_DRD/images/raw/test |sort -R |tail -n 110 |while read file; do
	cp  /storage/hpc_anna/Kaggle_DRD/images/raw/test/$file /storage/hpc_anna/Kaggle_DRD/sample_images/raw/test
done
