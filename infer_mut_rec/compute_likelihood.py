import math
import numpy as np
from scipy.stats import poisson
from decimal import *
getcontext().prec=12


def compute_likelihood(args):
	"""
	This function computes the likelihood for one window
	:param simulated_rhos_path:
	:param phi:
	:param mu:
	:param N:
	:param tsplit:
	:param recs:
	:param lengths:
	:param segsites:
	:param b_vals:
	:param result_file:
	:return: the likelihood for a window
	"""
	phi, mu, N, tsplit, rec, length, segsite, b_val = args

	simulated_rhos_path = '/u/project/klohmuel/tanya_data/Mutagenic_Recombination/outputs/simulate_rhos/simulated_rhos_1000reps/' #TODO: figure out how to not hard code this
	poisson_ll = 0
	# Step 1: compute rho = 4NBrL and round up the the nearest integer
	rho = 4 * N * b_val * (rec * 10**(-8)) * length
	rho_round = int(round(rho))
	# NOTES: Right now the range of rho is explicitly set to be checked between 0 and 2000 because I have simulated rhos between 0 and 2000.
	# However, TODO: make the range of rho as a parameter.
	if rho_round >= 0 and rho_round <= 2000:

		# Step 2: Compute the poisson likelihood for each genealogy (1000 replicates of the genealogy for each rho_round)
		genealogies = []
		# Get the genealogy file
		with open(simulated_rhos_path + '/rho' + str(rho_round) + '_1000reps', "r") as f:
			next(f)
			for line in f:
				line = line.rstrip('\n')
				line = line.split()
				genealogies.append(float((line[0])))

		# poisson rate = (mu + phi*rec * (2T*2NB+tsplit) * L)
		poisson_rate_genealogies = [(mu + phi*(rec * 10**(-8)))*(2*(genealogy*2*N*b_val+tsplit)*length) for genealogy in genealogies]

		genealogies_prob = poisson.pmf(segsite, poisson_rate_genealogies)
		genealogies_prob_mean = np.mean(genealogies_prob)

		if genealogies_prob_mean > 0:
			poisson_ll = math.log10(genealogies_prob_mean)
		else:
			genealogies_prob_log = poisson.logpmf(segsite, poisson_rate_genealogies)
			genealogies_prob_log_exp = [Decimal(int(round(j))).exp() for j in genealogies_prob_log]
			genealogies_prob_log_exp_mean = np.sum(genealogies_prob_log_exp)/1000 #TODO: make this 1000 to be a parameter instead
			poisson_ll = Decimal(genealogies_prob_log_exp_mean).log10()

	return poisson_ll