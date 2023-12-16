library(distantia)

#TESTING WITH IDENTICAL MATRICES

#creating identical matrices
a <- b <- matrix(
  c(rep(1:6, 2)),
  nrow = 6,
  ncol = 2
)

a


#computing psi
psi.ab <- psi_cpp(
  a,
  b,
  method = "euc"
  )
psi.ab

#null distribution with dependent columns
null.ab.independent <- null_psi_cpp(
  a,
  b,
  method = "euc"
  )
mean(null.ab.independent)

#null distribution with independent column
null.ab <- null_psi_cpp(
  a,
  b,
  method = "euc",
  independent = FALSE
  )
mean(null.ab)

#TESTING WITH sequenceA and sequenceB
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

#permuted versions
a_ <- permute_independent_cpp(
  x = a,
  block_size = 2,
  1
)

sum(a == a_)
sum(a != a_)

b_ <- permute_independent_cpp(
  x = b,
  block_size = 2,
  2
)

sum(b == b_)
sum(b != b_)

#create sequences_ for old version
sequences_ <- rbind(
  as.data.frame(a_),
  as.data.frame(b_)
  )
sequences_$id <- c(
  rep("A", nrow(a)),
  rep("B", nrow(b))
)

#compute psi for non-permutted sequences
psi.ab <- psi_cpp(a, b)
psi.ab_ <- psi_cpp(a_, b_)
psi.ab.old <- workflowPsi(
  sequences = sequences,
  method = "euclidean",
  diagonal = FALSE,
  paired.samples = FALSE,
  same.time = FALSE,
  format = "data.frame",
  parallel.execution = FALSE
)$psi

psi.ab.old_ <- workflowPsi(
  sequences = sequences_,
  method = "euclidean",
  diagonal = FALSE,
  paired.samples = FALSE,
  same.time = FALSE,
  format = "data.frame",
  parallel.execution = FALSE
)$psi




#compute distance matrices
dist_matrix <- distance_matrix_cpp(a, b)
dist_matrix_ <- distance_matrix_cpp(a_, b_)
sum(dist_matrix == dist_matrix_)

plotMatrix(dist_matrix)
plotMatrix(dist_matrix_)

#compute cost matrices
cost_matrix <- cost_matrix_cpp(dist_matrix)
cost_matrix_ <- cost_matrix_cpp(dist_matrix_)

plotMatrix(cost_matrix)
plotMatrix(cost_matrix_)

#compute cost paths
cost_path = cost_path_cpp(dist_matrix, cost_matrix)
cost_path_ = cost_path_cpp(dist_matrix_, cost_matrix_)

plotMatrix(cost_matrix, cost_path)
plotMatrix(cost_matrix_, cost_path_)

#cost path sum
cost_path_sum <- cost_path_sum_cpp(cost_path)
cost_path_sum_ <- cost_path_sum_cpp(cost_path_)

cost_path_sum
cost_path_sum_

#auto sum
ab_sum = auto_sum_no_path_cpp(
  a,
  b
)

ab_sum_ = auto_sum_no_path_cpp(
  a_,
  b_
)

ab_sum
ab_sum_

#psi scores
psi_score = ((cost_path_sum * 2) - ab_sum) / ab_sum
psi_score_ = ((cost_path_sum_ * 2) - ab_sum) / ab_sum

















#psi test
print(head(a[, 1:3]))
x <- null_psi_test(
  a,
  b,
  block_size = 3,
  seed = 1
)
print(head(x[, 1:3]))


#check permutations of a
print(head(a[, 1:3]))

psi_cpp(
  a,
  b
)

repetitions <- 100
psi_null <- vector(length = repetitions)

for(i in 1:repetitions){

  permuted_a <- permute_cpp(
    x = a,
    block_size = nrow(a),
    i
  )

  permuted_b <- permute_cpp(
    x = b,
    block_size = nrow(b),
    i
  )

  psi_null[i] <- psi_cpp(
    permuted_a,
    permuted_b
  )


}

psi_null



#computing psi
psi.ab <- psi_cpp(
  a = a,
  b = b,
  method = "euc"
)
psi.ab

#null distribution with dependent columns
null.ab.independent <- null_psi_cpp(
  a = a,
  b = b,
  method = "euc",
  block_size = c(2, 3, 4, 5)
)
mean(null.ab.independent)

#null distribution with independent column
null.ab <- null_psi_cpp(
  a,
  b,
  method = "euc",
  independent = FALSE
)
mean(null.ab)
