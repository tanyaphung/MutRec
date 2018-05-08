#!/bin/bash
. /u/local/Modules/default/init/modules.sh
module load R

# GOAL: To simulate human chimp divergence. 
# This script involves 3 parts:
# First, it calls the R script simulate_ancestral_theta_rho.R to simulate ancestral theta and rho.
# Second, it calls ms to simulate ancestral divergence
# Third, it calls the R script simulate_human_chimp_divergence.R to simulate divergence since the split and combines it with the ancestral divergence from step 2

# The empirical data is from Phung et al. PLoS Genetics 2016

####################################################################################
# Simualate a divergence dataset that was affected by background selection by itself
####################################################################################

mkdir BGS

# Step 1:
Rscript simulate_ancestral_theta_rho.R human_chimp_empirical_rmB0.txt 2e-8 50000 BGS BGS/ancestral_theta_rho.out 

# Step 2:
num_windows=17350
theta_rho_ancestral=BGS/ancestral_theta_rho.out
ancestral_divergence_out=BGS/ancestral_divergence.out
msdir/ms 2 ${num_windows} -t tbs -r tbs 100000 < ${theta_rho_ancestral} | grep segsites > ${ancestral_divergence_out}

# Step 3:
Rscript simulate_human_chimp_divergence.R human_chimp_empirical_rmB0.txt 2e-8 0 200000 BGS/ancestral_divergence.out BGS/simulated_divergence_BGS.txt

#######################################################################################
# Simualate a divergence dataset that was affected by mutagenic recombination by itself
#######################################################################################

mkdir MutRec

# Step 1:
Rscript simulate_ancestral_theta_rho.R human_chimp_empirical_rmB0.txt 2e-8 50000 MutRec MutRec/ancestral_theta_rho.out 

# Step 2:
num_windows=17350
theta_rho_ancestral=MutRec/ancestral_theta_rho.out
ancestral_divergence_out=MutRec/ancestral_divergence.out
msdir/ms 2 ${num_windows} -t tbs -r tbs 100000 < ${theta_rho_ancestral} | grep segsites > ${ancestral_divergence_out}

# Step 3:
Rscript simulate_human_chimp_divergence.R human_chimp_empirical_rmB0.txt 2e-8 0.05 200000 MutRec/ancestral_divergence.out MutRec/simulated_divergence_MutRec.txt

###########################################################################################################
# Simualate a divergence dataset that was affected by both background selection and mutagenic recombination
###########################################################################################################

mkdir BGS_MutRec

# Step 1:
Rscript simulate_ancestral_theta_rho.R human_chimp_empirical_rmB0.txt 2e-8 50000 BGS_MutRec BGS_MutRec/ancestral_theta_rho.out 

# Step 2:
num_windows=17350
theta_rho_ancestral=BGS_MutRec/ancestral_theta_rho.out
ancestral_divergence_out=BGS_MutRec/ancestral_divergence.out
msdir/ms 2 ${num_windows} -t tbs -r tbs 100000 < ${theta_rho_ancestral} | grep segsites > ${ancestral_divergence_out}

# Step 3:
Rscript simulate_human_chimp_divergence.R human_chimp_empirical_rmB0.txt 2e-8 0.05 200000 BGS_MutRec/ancestral_divergence.out BGS_MutRec/simulated_divergence_BGS_MutRec.txt