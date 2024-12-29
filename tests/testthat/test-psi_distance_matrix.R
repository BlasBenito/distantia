test_that("`psi_distance_matrix()` works", {
  d <- "euclidean"
  x <- zoo_simulate(name = "x", rows = 100, seasons = 2, seed = 1)
  y <- zoo_simulate(name = "y", rows = 80, seasons = 2, seed = 2)
  expect_equal(if (interactive()) {
    zoo_plot(x = x)
    zoo_plot(x = y)
  }, )
  dist_matrix <- psi_distance_matrix(x = x, y = y, distance = d)
  expect_equal(if (interactive()) {
    utils_matrix_plot(m = dist_matrix)
  }, )
})
