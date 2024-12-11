test_that("`psi_distance_lock_step()` works", {
  d <- "euclidean"
  x <- zoo_simulate(name = "x", rows = 100, seasons = 2, seed = 1)
  y <- zoo_simulate(name = "y", rows = 100, seasons = 2, seed = 2)
  expect_equal(if (interactive()) {
    zoo_plot(x = x)
    zoo_plot(x = y)
  }, )
  expect_equal(psi_distance_lock_step(x = x, y = y, distance = d), )
})
