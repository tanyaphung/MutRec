from parse_args import *
from compute_likelihood import *
import numpy as np
from compute_bval import *

def main():

	args = parse_args()

	result_file = open(args.result_file, 'w')

	# Load empirical data
	recs = []
	lengths = []
	segsites = []
	b_vals = []

	with open(args.empirical) as f:
		for line in f:
			if not line.startswith("start"):
				line = line.rstrip("\n")
				line = line.split("\t")
				recs.append(float(line[5]))
				lengths.append(float(line[2]))
				segsites.append(float(line[3]))
				if args.model == 'BGS' or args.model == 'BGS_MutRec':
					if args.bvals == 'McVicker':
						b_vals.append(float(line[6]))
					if args.bvals == 'Hudson_Kaplan':
						b_vals.append(compute_bval(float(args.U), float(args.sh), float(line[5])/1000))
				if args.model == 'MutRec':
					b_vals.append(1)

	phis = []
	mus = []
	Ns = []
	tsplits = []

	for i in range(len(recs)):
		phis.append(float(args.phi))
		mus.append(float(args.mu))
		Ns.append(float(args.N))
		tsplits.append(float(args.tsplit))

	# Compute likelihoods
	likelihoods = list(map(compute_likelihood, zip(phis, mus, Ns, tsplits, recs, lengths, segsites, b_vals)))

	# for i in likelihoods:
	# 	print (i)

	# Compute sum of likelihoods across all windows
	sum_likelihoods = 0
	for i in likelihoods:
		sum_likelihoods += float(i)

	to_print = [args.phi, args.mu, args.N, args.U, args.sh, args.tsplit, str(sum_likelihoods)]
	result_file.write('\t'.join(to_print) + '\n')
	result_file.close()

if __name__ == '__main__':
	main()