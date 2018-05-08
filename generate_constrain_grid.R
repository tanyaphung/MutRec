# This script generates a grid of values of (phi, mu, N) and applies the contraining function based on the mean diversity to reduce the total number of parameter sets.

# Usage: Rscript generate_constrain_grid.R
# input 1: Path to the data (could be empirical or simulated data)
# input 2: Path to where to save the constrained grid
# input 3: Enter either "BGS", "MutRec", or "BGS_MutRec"
# input 4, 5, and 6: from, to, by for phi
# input 7, 8, and 9: from, to, by for mu
# input 10, 11, and 12: from, to, by for N

# NOTES: Change the values of phi, mu, and N to specific analyses

inputs = commandArgs(trailingOnly=T)

# Write a function that computes the expected divergence
expected_div = function(mu, phi, recs_adjusted, N_use, tsplit, lengths) {
  ((mu + phi*recs_adjusted)*(2*(1*2*N_use+tsplit)*lengths))
}

# Write a function to check whether the expected divergence computed from the set of parameters is within 10% of the mean divergence from the empirical data
check_func = function(row, mean_div_low, mean_div_high) {
  # Compute b-values
  N_adjust = row[3]*bvals

  # Compute expected divergence
  div = expected_div(mu=row[2], phi=row[1], recs_adjusted=recs_adjusted, N_use=N_adjust, tsplit=row[4], lengths=lengths)
  mean_div = mean(div/lengths)
  if (mean_div >= low && mean_div <= high) {
    return (row)
  }
}

# Load data. Calculate the mean divergence and the values for being within 10% of the mean
emp_data = read.table(inputs[1], header=T)

mean_div = round(mean(emp_data$divergence), digits = 4)
low = mean_div - mean_div * 0.01
high = mean_div + mean_div * 0.01

recs_adjusted = emp_data[,6] * 1e-8
lengths = emp_data[,3]

if (inputs[3] == "BGS"){
  bvals = emp_data[,7]
} else if (inputs[3] == "MutRec") {
  bvals = 1
} else if (inputs[3] == "BGS_MutRec") {
  bvals = emp_data[,7]
}

# Generate set of parameters
require(utils)
phi = seq(from = as.numeric(inputs[4]), to = as.numeric(inputs[5]), by = as.numeric(inputs[6]))
mu = seq(from = as.numeric(inputs[7]), to = as.numeric(inputs[8]), by = as.numeric(inputs[9]))
N = seq(from = as.numeric(inputs[10]), to = as.numeric(inputs[11]), by = as.numeric(inputs[12]))
tsplit = 200000

parameters <- as.matrix(expand.grid(phi, mu, N, tsplit))

constrained_parameters <- apply(parameters, 1, check_func, low, high)
constrained_parameters[!sapply(constrained_parameters, is.null)]
output <- matrix(unlist(constrained_parameters), ncol = 4, byrow = TRUE)
write.table(output, inputs[2], quote=FALSE, row.names=FALSE, col.names=FALSE)
