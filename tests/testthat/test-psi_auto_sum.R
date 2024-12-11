test_that("`psi_auto_sum()` works", {
  d <- "euclidean"
  x <- zoo_simulate(name = "x", rows = 100, seasons = 2, seed = 1)
  y <- zoo_simulate(name = "y", rows = 80, seasons = 2, seed = 2)
  expect_equal(if (interactive()) {
    zoo_plot(x = x)
    zoo_plot(x = y)
  }, )
  expect_equal(psi_auto_sum(x = x, y = y, distance = d), )
  x_sum <- psi_auto_distance(x = x, distance = d)
  y_sum <- psi_auto_distance(x = y, distance = d)
  expect_equal(x_sum + y_sum, )
})
