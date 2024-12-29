test_that("`psi_cost_path_sum()` works", {
  d <- "euclidean"
  x <- zoo_simulate(name = "x", rows = 100, seasons = 2, seed = 1)
  y <- zoo_simulate(name = "y", rows = 80, seasons = 2, seed = 2)
  expect_equal(if (interactive()) {
    zoo_plot(x = x)
    zoo_plot(x = y)
  }, )
  dist_matrix <- psi_distance_matrix(x = x, y = y, distance = d)
  cost_matrix <- psi_cost_matrix(dist_matrix = dist_matrix)
  cost_path <- psi_cost_path(dist_matrix = dist_matrix, cost_matrix = cost_matrix)
  expect_equal(psi_cost_path_sum(path = cost_path), )
})
