test_that("`zoo_plot()` works", {
  x <- zoo_simulate()
  expect_equal(if (interactive()) {
    zoo_plot(x = x, xlab = "Date", ylab = "Value", title = "My time series")
  }, )
})
