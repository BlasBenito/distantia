library(distantia)

load("~/Dropbox/GITHUB/R_packages/distantia/data/sequencesMIS.RData")

#data frame with grouping column
###################################
x <- prepare_sequences(
  x = sequencesMIS,
  id_column = "MIS",
  time_column = NULL,
  paired_samples = FALSE,
  pseudo_zero =  0.001,
  na_action = "to_zero"
)

dist_matrix <- distance_matrix(
  a = x[[1]],
  b = x[[2]],
  distance = "euclidean"
)

plot_matrix(dist_matrix)

cost_matrix <- cost_matrix(dist_matrix = dist_matrix)

plot_matrix(m = cost_matrix)

path <- cost_path(
  dist_matrix = dist_matrix,
  cost_matrix = cost_matrix
)

plot_matrix(
  m = cost_matrix,
  path = path
  )
