import argparse


def parse_args():
	"""
	Parse command-line arguments
	"""
	parser = argparse.ArgumentParser(description="This script computes the likelihood given a grid point.")

	# parser.add_argument(
	# 		"--simulated_rhos_path", required=True,
	# 		help="REQUIRED. Give the path to the simulated rhos.")
	parser.add_argument(
			"--empirical", required=True,
			help="REQUIRED. Empirical information. This file should have 7 columns and should be for the whole genome. (1) Column 1 is start coordinate, (2) Column 2 is end coordinate, (3) Column 3 is the length, (4) Column 4 is the number of segregating sites, (6) Column 6 is recombination rate, and (7) Column 7 is the b-values.")
	parser.add_argument(
			"--phi", required=True,
			help="REQUIRED. phi")
	parser.add_argument(
			"--mu", required=True,
			help="REQUIRED. mu")
	parser.add_argument(
			"--N", required=True,
			help="REQUIRED. N")
	parser.add_argument(
			"--tsplit", required=True,
			help="REQUIRED. tsplit")
	parser.add_argument(
			"--model", required=True,
			help="REQUIRED. Indicate whether it is: BGS, MutRec, or BGS_MutRec.")
	parser.add_argument(
			"--bvals", required=True,
			help="REQUIRED. Indicate whether it is: Hudson_Kaplan or McVicker. If it is Hudson_Kaplan, input 0 for both U and sh.")
	parser.add_argument(
			"--U", required=True,
			help="REQUIRED. Input a value for U. If the input for bvals is Hudson_Kaplan, input 0.")
	parser.add_argument(
			"--sh", required=True,
			help="REQUIRED. Input a value for sh. If the input for bvals is Hudson_Kaplan, input 0.")
	parser.add_argument(
			"--result_file", required=True,
			help="REQUIRED. Name of the result file")

	args = parser.parse_args()
	return args


