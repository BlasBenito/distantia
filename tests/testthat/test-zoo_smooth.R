test_that("`zoo_smooth()` works", {

  x <- zoo_simulate(cols = 1, seed = 1)

  x_smooth <- zoo_smooth_exponential(x = x, alpha = 0.2)

  expect_true(sd(x[, 1]) > sd(x_smooth[, 1]))

  x_smooth <- zoo_smooth_window(x = x)

  expect_true(sd(x[, 1]) > sd(x_smooth[, 1]))

})
