test_that("`psi_auto_distance()` works", {
  d <- "euclidean"
  x <- zoo_simulate(name = "x", rows = 100, seasons = 2, seed = 1)
  expect_equal(psi_auto_distance(x = x, distance = d), )
})
