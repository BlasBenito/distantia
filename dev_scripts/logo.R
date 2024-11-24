tsl <- tsl_simulate(
  n = 2,
  rows = 10
)

m.dist <- psi_distance_matrix(
  x = tsl[[1]],
  y = tsl[[2]]
)

m.cost <- psi_cost_matrix(
  dist_matrix = m.dist,
  diagonal = FALSE
)

m.cost.path <- psi_cost_path(
  dist_matrix = m.dist,
  cost_matrix = m.cost,
  diagonal = FALSE
)

utils_matrix_plot(
  m = m.cost,
  path = m.cost.path,
  path_width = 3,
  path_color = "gray30",
  diagonal = FALSE,
  guide = FALSE
)
