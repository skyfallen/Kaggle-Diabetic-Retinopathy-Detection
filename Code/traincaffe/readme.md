#### Lists of images
First you need to produce `train.txt`, `val.txt` and `test.txt`. These files indicate which files will go for training, validation and test phases. To create those files run
* `Code/traincaffe/make_drdnet_labels.sh "" size256 train`
* `Code/traincaffe/make_drdnet_labels.sh "" size256 val`
* `Code/traincaffe/make_drdnet_labels.sh "" size256 test`


#### Create LMDB from images for Caffe
Run `Code/traincaffe/create_drdnet.sh "" size256`


#### Compute image means
Caffe needs it for some reason  
Run `Code/traincaffe/make_drdnet_mean.sh`


#### Prepare .prototxt files
##### Training and validation
Describe your network (for examples `Code/traincaffe/networks/network_basic.prototxt`)  
* Training parameters
  * In `data` layer for `TRAIN` phase set `transform_param -> mean_file` to point at `caffeinput/PREPROC/drdnet_mean_train.binaryproto`  
  * In `data` layer for `TRAIN` phase set `data_param -> source` to point at `caffeinput/PREPROC/ilsvrc12_train_lmdb`  
* Validation parameters
  * In `data` layer for `TEST` phase set `transform_param -> mean_file` to point at `caffeinput/PREPROC/drdnet_mean_val.binaryproto`
  * In `data` layer for `TEST` phase set `data_param -> source` to point at `caffeinput/PREPROC/ilsvrc12_val_lmdb`  

where `PREPROC` is the preprocessing type (for example `size256`)

##### Solver
`solver.prototxt` lists training parameters.  
Set `net:` to point at the network structure description for training and validation(for exampe `Code/traincaffe/networks/network_basic.prototxt`).  
Set `snapshot_prefix:` to point at the location to store trained model(s).  
Think about all the other parameters you see in there.

##### Testing
Testing parameters are given in `Code/traincaffe/networks/network_basic_test.prototxt`  
`TRAIN` phase is ignored by `extract_features` when reading network activations (activations of the final layer are the predictions we are looking for)  
* In `data` layer for `TEST` phase set `transform_param -> mean_file` to point at `caffeinput/PREPROC/drdnet_mean_test.binaryproto`
* In `data` layer for `TEST` phase set `data_param -> source` to point at `caffeinput/PREPROC/ilsvrc12_test_lmdb`  

#### Train the model
Training should be started from Caffe root directory as follows:  
```
srun --partition=gpu --gres=gpu:1 --constraint=K20 --mem=10000 ./build/tools/caffe train --solver=/home/$USER/Kaggle/Diabetic-Retinopathy-Detection/Code/traincaffe/networks/solver.prototxt
```

#### Apply model to test images
For some reason there is no convinient way to just apply model to new data. We use `extract_features.bin` scripts to extract activations of the last layer (`prob`).  
After that we extract classes from LMDB base.  
To perform these steps run `Code/traincaffe/test_drdnet.sh`.  
Results will be stored to `/storage/hpc_anna/Kaggle_DRD/PREFIXpredictions/PREPROC/predictions_MODELNAME.txt`

