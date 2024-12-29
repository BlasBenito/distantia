test_that("`zoo_aggregate()` works", {
  x <- zoo_simulate(rows = 1000, time_range = c("0000-01-01", as.character(Sys.Date())))
  expect_equal(if (interactive()) {
    zoo_plot(x)
  }, )
  x_time <- zoo_time(x)
  expect_equal(x_time$keywords, )
  x_millennia <- zoo_aggregate(x = x, new_time = "millennia", f = mean)
  expect_equal(if (interactive()) {
    zoo_plot(x_millennia)
  }, )
  x_centuries <- zoo_aggregate(x = x, new_time = "centuries", f = max)
  expect_equal(if (interactive()) {
    zoo_plot(x_centuries)
  }, )
  x_centuries <- zoo_aggregate(
    x = x, new_time = "centuries", f = stats::quantile,
    probs = 0.75
  )
  expect_equal(if (interactive()) {
    zoo_plot(x_centuries)
  }, )
})
