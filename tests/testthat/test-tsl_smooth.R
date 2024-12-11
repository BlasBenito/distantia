test_that("`tsl_smooth()` works", {
  expect_equal(future::plan(future::multisession, workers = 2), )
  tsl <- tsl_simulate(n = 2)
  tsl_smooth <- tsl_smooth(tsl = tsl, window = 5, f = mean)
  expect_equal(if (interactive()) {
    tsl_plot(tsl)
    tsl_plot(tsl_smooth)
  }, )
  tsl_smooth <- tsl_smooth(tsl = tsl, alpha = 0.2)
  expect_equal(if (interactive()) {
    tsl_plot(tsl)
    tsl_plot(tsl_smooth)
  }, )
  expect_equal(future::plan(future::sequential), )
})
