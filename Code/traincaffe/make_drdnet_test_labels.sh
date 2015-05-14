#
# Creates file with image names	and zeros instead of labels for	test
#

#!/bin/bash
cd /storage/hpc_anna/Kaggle_DRD/sample_images/size256/test
ls * | sed 's/$/ 0/' > /storage/hpc_anna/Kaggle_DRD/sample_caffeinput/size256/test.txt


