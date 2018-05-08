# GOAL: To simulate ancestral theta and rho as the first part of simulating human-chimp divergence

# Usage: Rscript simulate_ancestral_theta_rho.R:
# input1: Path to the empirical data file
# input2: Input a value for mu
# input3: Input a value for N
# input4: Input either: BGS, MutRec, or BGS_MutRec
# input5: Path to the file where to save the ancestral theta rho file

inputs = commandArgs(TRUE)

# Load empirical data
emp_data = read.table(inputs[1], header=T)

# Process variables
recs = emp_data[,6]
recs_adjusted = recs * 1e-8
lengths = emp_data[,3]
bvals = emp_data[,7]

# Get the parameters from command line arguments
mu = as.numeric(inputs[2])
N = as.numeric(inputs[3])

# Adjust N by bvals
if (inputs[4] == "BGS"){
  N_use = N*bvals
} else if (inputs[4] == "MutRec") {
  N_use = N*1
} else if (inputs[4] == "BGS_MutRec") {
  N_use = N*bvals
}

# Do computation
theta_ancestral <- N_use*4*lengths*mu
rho_ancestral <- N_use*4*recs_adjusted*lengths
theta_rho_ancestral_out <- cbind(theta_ancestral, rho_ancestral)

write.table(theta_rho_ancestral_out, inputs[5], quote=FALSE,row.names=FALSE,col.names=FALSE, sep="\t")