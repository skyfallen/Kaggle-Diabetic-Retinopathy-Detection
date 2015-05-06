ls  /storage/hpc_anna/Kaggle_DRD/input/raw/train |sort -R |tail -n 7026 |while read file; do
	mv  /storage/hpc_anna/Kaggle_DRD/input/raw/train/$file /storage/hpc_anna/Kaggle_DRD/input/raw/val
	#echo "/storage/hpc_anna/Kaggle_DRD/input/raw/train/$file /storage/hpc_anna/Kaggle_DRD/input/raw/val"
done
