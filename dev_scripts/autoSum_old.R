library(tictoc)
library(distantia)
method = "euclidean"

#prepare sequences
##################################
data(sequenceA)
data(sequenceB)

sequences <- prepareSequences(
  sequence.A = sequenceA,
  sequence.B = sequenceB,
  merge.mode = "overlap",
  if.empty.cases = "omit",
  transformation = "hellinger"
)

a <- sequences |>
  dplyr::filter(
    id == "A"
  ) |>
  dplyr::select(-id) |>
  as.matrix()

b <- sequences |>
  dplyr::filter(
    id == "B"
  ) |>
  dplyr::select(-id) |>
  as.matrix()

#least cost path
##################################
dist_matrix <- distance_matrix_cpp(
  a, b, method
)

cost_matrix <- cost_matrix_cpp(
  dist_matrix
)

path <- cost_path_cpp(
  dist_matrix,
  cost_matrix
)

#auto_distance_cpp GOOD!
##################################

a_autosum <- auto_distance_cpp(
  a, method
)

b_autosum <- auto_distance_cpp(
  b, method
)

a_autosum + b_autosum


#autosum old no path GOOD!
#this is the core algorithm of autosum
##################################
tic()
a_autosum_old <- vector()
for (j in 1:(nrow(a)-1)){
  a_autosum_old[j] <- distantia::distance_methods(x = a[j, ], y = a[j+1, ], method = method)
}
sum(a_autosum_old)
toc()

b_autosum_old <- vector()
for (j in 1:(nrow(b)-1)){
  b_autosum_old[j] <- distantia::distance_methods(x = b[j, ], y = b[j+1, ], method = method)
}
sum(b_autosum_old)

sum(sum(a_autosum_old), sum(b_autosum_old))


auto_sum_no_path_cpp(a, b, method)

