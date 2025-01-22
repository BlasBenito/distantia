#distance metric
d <- "euclidean"

options(scipen = 9999)
options(digits = 10)

#simulate two irregular time series
x <- zoo_simulate(
  name = "x",
  rows = 100,
  seasons = 2,
  seed = 1
  )

y <- x

tsl <- tsl_init(
  x = list(
    x = x,
    y  = y
  )
)

#same result, negative zero
distantia(tsl, diagonal = FALSE)$psi

psi_dtw_cpp(
  x = x,
  y = y,
  distance = "euclidean",
  diagonal = FALSE,
  weighted = FALSE,
  ignore_blocks = FALSE,
  bandwidth = 1
)

#step by step inside psi_dtw_cpp
path = cost_path_cpp(
  x = x,
  y = y,
  distance = "euclidean",
  diagonal = FALSE,
  weighted = FALSE,
  ignore_blocks = FALSE,
  bandwidth = 1
)

a = cost_path_sum_cpp(path)

b = auto_sum_cpp(
  x = x,
  y = y,
  path = path,
  distance = "euclidean",
  ignore_blocks = FALSE
)

psi_equation_cpp(
  a = a,
  b = b,
  diagonal = FALSE
)

#step by step with psi functions alongside cpp ones
dist_matrix <- psi_distance_matrix(
  x = x,
  y = y,
  distance = d
)

dist_matrix_ <- distance_matrix_cpp(
  x = x,
  y = y,
  distance = d
)

sum(dist_matrix - dist_matrix_)


cost_matrix <- psi_cost_matrix(
  dist_matrix = dist_matrix,
  diagonal = FALSE
)

cost_matrix_ <- cost_matrix_orthogonal_cpp(
  dist_matrix = dist_matrix
)

sum(cost_matrix - cost_matrix_)


cost_path <- psi_cost_path(
  dist_matrix = dist_matrix,
  cost_matrix = cost_matrix,
  diagonal = FALSE
)

cost_path_ <- cost_path_orthogonal_cpp(
  dist_matrix = dist_matrix,
  cost_matrix = cost_matrix
)

cost_path_ <- cost_path_cpp(
  x = x,
  y = y,
  distance = d,
  diagonal = FALSE,
  weighted = FALSE,
  ignore_blocks = FALSE,
  bandwidth = 1
)

head(cost_path)
head(cost_path_)


a <- psi_cost_path_sum(
  path = cost_path
  )

a_ <- cost_path_sum_cpp(
  path = cost_path_
)

a
a_


b <- psi_auto_sum(
  x = x,
  y = y,
  distance = d
)

b_ = auto_sum_cpp(
  x = x,
  y = y,
  path = cost_path,
  distance = d,
  ignore_blocks = FALSE
)

b_ <- auto_sum_full_cpp(
  x = x,
  y = y,
  distance = d
)

a #from R
a_ #from C++

b #from R
b_ #from C++

((2 * a) / b)
((2 * a_) / b_)

((2 * a) / b) - 1
((2 * a_) / b_) - 1

#dissimilarity score
psi_equation(
  a = a,
  b = b,
  diagonal = FALSE
)

psi_equation_cpp(
  a = a,
  b = b,
  diagonal = FALSE
)


