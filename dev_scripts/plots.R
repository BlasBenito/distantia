library(distantia)

load("~/Dropbox/GITHUB/R_packages/distantia/data/sequencesMIS.RData")

#data frame with grouping column
###################################
data(sequencesMIS)

#prepare list of sequences
x <- prepare_sequences(
  x = sequencesMIS,
  id_column = "MIS",
  time_column = NULL,
  paired_samples = FALSE,
  pseudo_zero =  0.001,
  na_action = "to_zero"
)

#distance matrix of the first two sequences
dist_matrix <- distance_matrix(
  a = x[[1]],
  b = x[[2]],
  distance = "euclidean"
)

#cost matrix
cost_matrix <- cost_matrix(
  dist_matrix = dist_matrix
  )

#least cost path
path <- cost_path(
  dist_matrix = dist_matrix,
  cost_matrix = cost_matrix,
  diagonal = TRUE
)

#plot cost matrix and least cost path
plot_matrix(
  m = cost_matrix,
  path = path
  )
