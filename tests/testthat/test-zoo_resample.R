test_that("`zoo_resample()` works", {
  x <- zoo_simulate(cols = 2, rows = 50, time_range = c(
    "2010-01-01",
    "2020-01-01"
  ), irregular = TRUE)
  expect_equal(if (interactive()) {
    zoo_plot(x)
  }, )
  x_intervals <- diff(zoo::index(x))
  expect_equal(x_intervals, )
  new_time <- seq.Date(
    from = min(zoo::index(x)), to = max(zoo::index(x)),
    by = floor(min(x_intervals))
  )
  expect_equal(new_time, )
  expect_equal(diff(new_time), )
  x_linear <- zoo_resample(x = x, new_time = new_time, method = "linear")
  x_spline <- zoo_resample(
    x = x, new_time = new_time, method = "spline",
    max_complexity = TRUE
  )
  x_loess <- zoo_resample(
    x = x, new_time = new_time, method = "loess",
    max_complexity = TRUE
  )
  expect_equal(diff(zoo::index(x_linear)), )
  expect_equal(diff(zoo::index(x_spline)), )
  expect_equal(diff(zoo::index(x_loess)), )
  expect_equal(if (interactive()) {
    par(mfrow = c(4, 1), mar = c(3, 3, 2, 2))
    zoo_plot(x, guide = FALSE, title = "Original")
    zoo_plot(x_linear, guide = FALSE, title = "Method: linear")
    zoo_plot(x_spline, guide = FALSE, title = "Method: spline")
    zoo_plot(x_loess, guide = FALSE, title = "Method: loess")
  }, )
})
