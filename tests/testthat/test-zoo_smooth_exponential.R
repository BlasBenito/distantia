test_that("`zoo_smooth_exponential()` works", {
  x <- zoo_simulate()
  x_smooth <- zoo_smooth_exponential(x = x, alpha = 0.2)
  expect_equal(if (interactive()) {
    zoo_plot(x)
    zoo_plot(x_smooth)
  }, )
})
