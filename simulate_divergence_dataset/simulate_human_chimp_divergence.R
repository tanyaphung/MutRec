# GOAL: To simulate since the split time divergence and combine with the ancestral divergence as the second part of simulating human-chimp divergence

# Usage: Rscript simulate_human_chimp_divergence.R:
# input1: Path to the empirical file
# input2: Input a value for mu
# input3: Input a value for phi
# input4: Input a value for tsplit
# input5: Path to the ancestral divergence
# input6: Path to the file where to save the simulated divergence data

inputs = commandArgs(TRUE)

# Load empirical data
emp_data = read.table(inputs[1], header=T)

# Process variables
recs = emp_data[,6]
recs_adjusted = recs * 1e-8
lengths = emp_data[,3]

# Get the parameters from command line arguments
mu = as.numeric(inputs[2])
phi = as.numeric(inputs[3])
tsplit = as.numeric(inputs[4])

# Load ancestral divergence data

ancestral_div <- read.table(inputs[5]) 

total_div <- ancestral_div[,2] + rpois(length(lengths), tsplit*2*(mu+phi*recs_adjusted)*lengths)

out = cbind(emp_data[,1], emp_data[,2], emp_data[,3], total_div, total_div/lengths, emp_data[,6], emp_data[,7])
colnames(out) = c("start", "end", "num_alignable", "num_divergence", "divergence", "recs", "bvals")

write.table(out, inputs[6], quote=FALSE, row.names=FALSE, sep="\t")
