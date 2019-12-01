import json
import sys
import numpy
from numpy import log, exp, pi
import scipy.stats, scipy
import pymultinest
import matplotlib.pyplot as plt
from subprocess import *

# Prior  1506.02603
def prior(cube, ndim, nparams):
	cube[0] = (cube[0]*0.02)+0.46   #0.46-0.48                         # --> gm2 (1e-4,20)
	cube[1] = cube[1]*0.0                                    # --> Delta (0,180)Degree
	cube[2] = (cube[2]*(0.005))+0.01 # 0.01-0.015                        # --> a (1e-5,1)
	cube[3] = (cube[3]*(0.01))+0.25  # 0.25-0.26                        # --> b (1e-5,1)
	cube[4] = cube[4]*0.0                                   # --> phi1 (0,180)Degree
	cube[5] = cube[5]*0.0                                    # --> phi2 (0,180)Degree


def model(cube):
	point = []
	par1 = 'Get["HSMU_REAP`"];'
	par2 = 'HSMU_REAP`inp[' + str(cube[0]) + ',' + str(cube[1]) + ',' + str(cube[2]) + ',' + str(cube[3]) + ',' + str(cube[4]) + ',' + str(cube[5]) + ']'
	command='/usr/local/bin/runMath'
	args = ([command,par1+par2])
	process = Popen(args, stdout=PIPE)
	data = process.communicate()
	for j in range(7):
			try:
				point.append((float(data[0].split()[j-7])))
			except:
				point.append(0.0)
	return point

def gausslike(x, mu, sigmaL, sigmaR):
	coe = ((2/numpy.pi)**0.5) / (sigmaL + sigmaR)
	if (x<mu):
		return coe * exp(-0.5 * ((x - mu) / sigmaL)**2) 
	else:
		return coe * exp(-0.5 * ((x - mu) / sigmaR)**2) 

def loglike(cube, ndim, nparams):
	point = model(cube)
	theta12, theta13, theta23, delta, deltaM32, deltaM21, mee = point[0], point[1], point[2],point[5],point[3],point[4], point[6]
	likelihood = gausslike(theta12, 33.82, 0.76, 0.78) * \
	gausslike(theta13, 8.61, 0.13, 0.12) * gausslike(theta23, 49.7, 1.1, 0.9) * \
	gausslike(delta,217,28,40)*gausslike(deltaM21, 7.39*1e-5, 0.20*1e-5, 0.21*1e-5)*gausslike(deltaM32, 2.525*1e-3, 0.031*1e-3, 0.033*1e-3)* \
	gausslike(mee, 0.185, 0.75, 0.75)
	return numpy.log(likelihood)

# number of dimensions our problem has
parameters = ["gm2", "Delta", "a", "b", "phi1", "phi2"]
n_params = len(parameters)

# run MultiNest
pymultinest.run(loglike, prior, n_params,n_live_points=50, outputfiles_basename='out_1_', resume = False, verbose = True)
json.dump(parameters, open('out_1_params.json', 'w')) # save parameter names

a = pymultinest.Analyzer(outputfiles_basename='out_1_', n_params = n_params)

a_lnZ = a.get_stats()['global evidence']
print 
print '************************'
print 'MAIN RESULT: Evidence Z '
print '************************'
print '  log Z for model = %.1f' % (a_lnZ / log(10))
print


