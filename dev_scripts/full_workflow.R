library(distantia)

data(sequenceA, sequenceB)
diagonal = TRUE
method = "euclidean"

a <- sequenceA |>
  na.omit() |>
  as.matrix()

b <- sequenceB |>
  na.omit() |>
  as.matrix()

#wrappers
d <- distance_matrix(
  a,
  b,
  method = method
  )

m <- cost_matrix(
  dist_matrix = d,
  diagonal = diagonal
  )

path <- cost_path(
  dist_matrix = d,
  cost_matrix = m,
  diagonal = diagonal
  )

path_trim_r <- cost_path_trim(
  path = path
  )

path_sum <- cost_path_sum(path)

ab_sum <- auto_sum(
  a = a,
  b = b,
  path = path,
  method = method
)

psi <- psi_value(
  cost_path_sum = path_sum,
  auto_sum = ab_sum,
  diagonal = diagonal
)

#cpp
###########################
a <- sequenceA |>
  na.omit() |>
  as.matrix()

b <- sequenceB |>
  na.omit() |>
  as.matrix()

d <- distance_matrix_cpp(
  a,
  b,
  f = distance_euclidean_cpp
)

m <- cost_matrix_cpp(
  dist_matrix = d
)

path <- cost_path_orthogonal_cpp(
  dist_matrix = d,
  cost_matrix = m
)

plotMatrix(m, path)

path_trim_r <- cost_path_trim_cpp(
  path = path
)

path_sum <- cost_path_sum(path)

ab_sum <- auto_sum(
  a = a,
  b = b,
  path = path,
  method = method
)

psi <- psi_value(
  cost_path_sum = path_sum,
  auto_sum = ab_sum,
  diagonal = diagonal
)
