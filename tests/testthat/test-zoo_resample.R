test_that("`zoo_resample()` works", {

  x <- zoo_simulate(cols = 2, rows = 50, time_range = c(
    "2010-01-01",
    "2020-01-01"
  ), irregular = TRUE
  )


  x_intervals <- diff(zoo::index(x))

  expect_true(length(unique(x_intervals)) > 1)

  new_time <- seq.Date(
    from = min(zoo::index(x)), to = max(zoo::index(x)),
    by = floor(min(x_intervals))
  )

  x_linear <- zoo_resample(x = x, new_time = new_time, method = "linear")

  expect_equal(
    new_time, zoo::index(x_linear)
  )

  x_spline <- zoo_resample(x = x, new_time = new_time, method = "spline")

  expect_equal(
    new_time, zoo::index(x_spline)
  )

  x_loess <- zoo_resample(x = x, new_time = new_time, method = "loess")

  expect_equal(
    new_time, zoo::index(x_loess)
  )


})
