library(distantia)

a <- sequenceA |>
  na.omit() |>
  as.matrix()

b <- sequenceB |>
  na.omit() |>
  as.matrix()

dist_matrix <- distance_matrix(a, b, method = "euclidean")

cost_matrix <- cost_matrix(dist_matrix = dist_matrix)

Rcpp::sourceCpp("src/cost_path.cpp")

#no diagonal
cost_path_r <- cost_path(
  dist_matrix = dist_matrix,
  cost_matrix = cost_matrix
)

plotMatrix(dist_matrix, cost_path_r)

cost_path_cpp <- cost_path_cpp(
  dist_matrix = dist_matrix,
  cost_matrix = cost_matrix
) |>
  as.data.frame()

plotMatrix(dist_matrix, cost_path_cpp)

Rcpp::sourceCpp("src/cost_path.cpp")

#diagonal
cost_path_diag_r <- cost_path(
  dist_matrix = dist_matrix,
  cost_matrix = cost_matrix,
  diagonal = TRUE
)

plotMatrix(dist_matrix, cost_path_diag_r)

cost_path_diag_cpp <- cost_path_diag_cpp(
  dist_matrix = dist_matrix,
  cost_matrix = cost_matrix
) |>
  as.data.frame()

plotMatrix(dist_matrix, cost_path_diag_cpp)
