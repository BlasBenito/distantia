test_that("`tsl_simulate()` works", {
  expect_equal(future::plan(future::multisession, workers = 2), )
  tsl <- tsl_simulate(n = 2, seasons = 4)
  expect_equal(if (interactive()) {
    tsl_plot(tsl = tsl)
  }, )
  tsl_independent <- tsl_simulate(n = 3, cols = 3, independent = TRUE)
  expect_equal(if (interactive()) {
    tsl_plot(tsl = tsl_independent)
  }, )
  tsl_dependent <- tsl_simulate(n = 3, cols = 3, independent = FALSE)
  expect_equal(if (interactive()) {
    tsl_plot(tsl = tsl_dependent)
  }, )
  tsl_seasons <- tsl_simulate(n = 3, cols = 3, seasons = 4, independent = FALSE)
  expect_equal(if (interactive()) {
    tsl_plot(tsl = tsl_seasons)
  }, )
  expect_equal(future::plan(future::sequential), )
})
