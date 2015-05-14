srun --partition=gpu --gres=gpu:1 --constraint=K20 --mem=20000 \
./extract_features.bin /storage/hpc_anna/Kaggle_DRD/sample_caffeinput/size256/model_basic_iter_1000.caffemodel \
/home/hpc_anna1985/Kaggle/Diabetic-Retinopathy-Detection/Code/traincaffe/models/network_basic_test.prototxt \
prob \
/storage/hpc_anna/Kaggle_DRD/sample_features/size256/features_basic 10 lmdb
