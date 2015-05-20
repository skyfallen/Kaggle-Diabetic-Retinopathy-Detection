import scipy.misc
import numpy as np
import random

ntrain = 1000
nval = 100
ntest = 2000

datafolder = '/storage/hpc_kuz/squares/images/raw'


def genimg(c):
    image = [0] * 4
    image[c] = 1
    image = np.reshape(image, (2, 2))
    return image

print 'Generating training images...'
with open(datafolder + '/train.txt', 'w') as f:
    for i in range(ntrain):
        c = random.randint(0, 3)
        image = genimg(c)
        scipy.misc.imsave(datafolder + '/train/' + str(i) + '.jpg', image)
        f.write(str(i) + '.jpg ' + str(c) + '\n')

print 'Generating validation images...'
with open(datafolder + '/val.txt', 'w') as f:
    for i in range(nval):
        c = random.randint(0, 3)
        image = genimg(c)
        scipy.misc.imsave(datafolder + '/val/' + str(i) + '.jpg', image)
        f.write(str(i) + '.jpg ' + str(c) + '\n')

print 'Generating test images...'
with open(datafolder + '/test.txt', 'w') as f:
    for i in range(ntest):
        c = random.randint(0, 3)
        image = genimg(c)
        scipy.misc.imsave(datafolder + '/test/' + str(i) + '.jpg', image)
        f.write(str(i) + '.jpg ' + str(c) + '\n')

print 'Done'



