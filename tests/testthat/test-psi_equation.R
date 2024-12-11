test_that("`psi_equation()` works", {
  d <- "euclidean"
  diagonal <- TRUE
  x <- zoo_simulate(name = "x", rows = 100, seasons = 2, seed = 1)
  y <- zoo_simulate(name = "y", rows = 80, seasons = 2, seed = 2)
  expect_equal(if (interactive()) {
    zoo_plot(x = x)
    zoo_plot(x = y)
  }, )
  dist_matrix <- psi_distance_matrix(x = x, y = y, distance = d)
  cost_matrix <- psi_cost_matrix(dist_matrix = dist_matrix, diagonal = diagonal)
  cost_path <- psi_cost_path(
    dist_matrix = dist_matrix, cost_matrix = cost_matrix,
    diagonal = diagonal
  )
  expect_equal(if (interactive()) {
    utils_matrix_plot(m = cost_matrix, path = cost_path)
  }, )
  a <- psi_cost_path_sum(path = cost_path)
  b <- psi_auto_sum(x = x, y = y, distance = d)
  expect_equal(psi_equation(a = a, b = b, diagonal = diagonal), )
  tsl <- list(x = x, y = y)
  expect_equal(distantia(tsl = tsl, distance = d, diagonal = diagonal)$psi, )
  expect_equal(if (interactive()) {
    distantia_plot(tsl = tsl, distance = d, diagonal = diagonal)
  }, )
})
