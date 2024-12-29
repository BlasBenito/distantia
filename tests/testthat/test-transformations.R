test_that("`f_binary()` works", {
  x <- zoo_simulate(data_range = c(0, 1))
  y <- f_binary(x = x, threshold = 0.5)
  expect_equal(if (interactive()) {
    zoo_plot(x)
    zoo_plot(y)
  }, )
})

test_that("`f_clr()` works", {
  x <- zoo_simulate(cols = 5, data_range = c(0, 500))
  y <- f_clr(x = x)
  expect_equal(if (interactive()) {
    zoo_plot(x)
    zoo_plot(y)
  }, )
})

test_that("`f_detrend_difference()` works", {
  x <- zoo_simulate(cols = 2)
  y_lag1 <- f_detrend_difference(x = x, lag = 1)
  y_lag5 <- f_detrend_difference(x = x, lag = 5)
  expect_equal(if (interactive()) {
    zoo_plot(x)
    zoo_plot(y_lag1)
    zoo_plot(y_lag5)
  }, )
})

test_that("`f_detrend_linear()` works", {
  x <- zoo_simulate(cols = 2)
  y <- f_detrend_linear(x = x)
  expect_equal(if (interactive()) {
    zoo_plot(x)
    zoo_plot(y)
  }, )
})

test_that("`f_detrend_poly()` works", {
  x <- zoo_simulate(cols = 2)
  y <- f_detrend_poly(x = x)
  expect_equal(if (interactive()) {
    zoo_plot(x)
    zoo_plot(y)
  }, )
})

test_that("`f_hellinger()` works", {
  x <- zoo_simulate(cols = 5, data_range = c(0, 500))
  y <- f_hellinger(x = x)
  expect_equal(if (interactive()) {
    zoo_plot(x)
    zoo_plot(y)
  }, )
})

test_that("`f_list()` works", {
  expect_equal(f_list(), )
})

test_that("`f_log()` works", {
  x <- zoo_simulate(cols = 5, data_range = c(0, 500))
  y <- f_log(x = x)
  expect_equal(if (interactive()) {
    zoo_plot(x)
    zoo_plot(y)
  }, )
})

test_that("`f_percent()` works", {
  x <- zoo_simulate(cols = 2)
  y <- f_percent(x = x)
  expect_equal(if (interactive()) {
    zoo_plot(x)
    zoo_plot(y)
  }, )
})

test_that("`f_proportion()` works", {
  x <- zoo_simulate(cols = 2)
  y <- f_proportion(x = x)
  expect_equal(if (interactive()) {
    zoo_plot(x)
    zoo_plot(y)
  }, )
})

test_that("`f_proportion_sqrt()` works", {
  x <- zoo_simulate(cols = 2)
  y <- f_proportion_sqrt(x = x)
  expect_equal(if (interactive()) {
    zoo_plot(x)
    zoo_plot(y)
  }, )
})

test_that("`f_rescale_global()` works", {
  x <- zoo_simulate(cols = 2)
  y <- f_rescale_global(x = x, new_min = 0, new_max = 100)
  expect_equal(if (interactive()) {
    zoo_plot(x)
    zoo_plot(y)
  }, )
})

test_that("`f_rescale_local()` works", {
  x <- zoo_simulate(cols = 2)
  y <- f_rescale_global(x = x, new_min = 0, new_max = 100)
  expect_equal(if (interactive()) {
    zoo_plot(x)
    zoo_plot(y)
  }, )
})

test_that("`f_scale_global()` works", {
  x <- zoo_simulate()
  y <- f_scale_global(x = x)
  expect_equal(if (interactive()) {
    zoo_plot(x)
    zoo_plot(y)
  }, )
})

test_that("`f_scale_local()` works", {
  x <- zoo_simulate()
  y <- f_scale_global(x = x)
  expect_equal(if (interactive()) {
    zoo_plot(x)
    zoo_plot(y)
  }, )
})

test_that("`f_trend_linear()` works", {
  x <- zoo_simulate(cols = 2)
  y <- f_trend_linear(x = x)
  expect_equal(if (interactive()) {
    zoo_plot(x)
    zoo_plot(y)
  }, )
})

test_that("`f_trend_poly()` works", {
  x <- zoo_simulate(cols = 2)
  y <- f_trend_poly(x = x)
  expect_equal(if (interactive()) {
    zoo_plot(x)
    zoo_plot(y)
  }, )
})
