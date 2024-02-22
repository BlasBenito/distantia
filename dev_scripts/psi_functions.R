library(distantia)

data("abernethy_a")
data("abernethy_b")

xy <- ts_initialize(
  x = list(
    a = abernethy_a,
    b = abernethy_b
  )
)

dist_matrix <- psi_dist_matrix(
  x = xy[["a"]],
  y = xy[["b"]]
)

cost_matrix <- psi_cost_matrix(
  dist_matrix = dist_matrix
)

cost_path <- psi_cost_path(
  dist_matrix = dist_matrix,
  cost_matrix = cost_matrix
)

cost_path <- psi_cost_path_trim_blocks(
  path = cost_path
)

cost_path_sum <- psi_cost_path_sum(
  path = cost_path
)

xy_sum <- psi_auto_sum(
  x = xy[["a"]],
  y = xy[["b"]]
)

x_sum <- psi_auto_distance(
  x = xy[["a"]]
)

score <- psi(
    path_sum = cost_path_sum,
    auto_sum = xy_sum
)

x11()
psi_plot(
  x = xy[["a"]],
  y = xy[["b"]]
)
