import numpy as np
import math
import random

def drd(lr_log10, fc1sizeX50, momentum, weightdecay, dropout, filtersizeX5, filternumX10):

    with open("kappa.txt",'r') as f:
    	result = f.readline()

    
    result = float(result)
    
    print 'Result = %f' % result
    #time.sleep(np.random.randint(60))
    return result

# Write a function like this called 'main'
def main(job_id, params):
    print 'Anything printed here will end up in the output directory for job #%d' % job_id
    print params
    return drd(params['lr_log10'], params['fc1sizeX50'], params['momentum'], params['weightdecay'], params['dropout'], params['filtersizeX5'], params['filternumX10'])
