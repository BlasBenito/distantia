library(distantia)

tsl <- tsl_init(
  x = distantia::cities_temperature,
  name = "name",
  time = "time"
)

x <- tsl[["London"]]
y <- tsl[["Kinshasa"]]

dist_matrix <- distance_matrix_cpp(
  x = x,
  y = y
)

cost_matrix <- cost_matrix_diagonal_weighted_cpp(
  dist_matrix = dist_matrix
)

cost_path <- cost_path_itakura_cpp(
  x = x,
  y = y,
  bandwidth = 0.5
)

utils_matrix_plot(
  m = cost_matrix,
  path = cost_path
)
