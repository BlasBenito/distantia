test_that("`zoo_smooth_window()` works", {
  x <- zoo_simulate()
  x_smooth <- zoo_smooth_window(x = x, window = 5, f = mean)
  expect_equal(if (interactive()) {
    zoo_plot(x)
    zoo_plot(x_smooth)
  }, )
})
